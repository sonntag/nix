#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>
#import <os/log.h>
#include <errno.h>
#include <pthread.h>
#include <signal.h>
#include <spawn.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>
#include <unistd.h>

extern char **environ;

static volatile sig_atomic_t childPid = -1;
static os_log_t lifecycleLog;
static os_log_t engineLog;
static pthread_mutex_t stateLock = PTHREAD_MUTEX_INITIALIZER;
static int virtualKeyboardReady = -1;
static int driverConnected = -1;

typedef struct {
  int fileDescriptor;
  bool isStandardError;
} OutputReaderContext;

static void initializeLogs(void) {
  lifecycleLog = os_log_create("org.sonntag.kanata", "lifecycle");
  engineLog = os_log_create("org.sonntag.kanata", "engine");
}

static void stripAnsiEscapeSequences(char *line) {
  char *readCursor = line;
  char *writeCursor = line;

  while (*readCursor != '\0') {
    if (readCursor[0] == '\033' && readCursor[1] == '[') {
      readCursor += 2;
      while (*readCursor != '\0' &&
             ((*readCursor >= '0' && *readCursor <= '9') ||
              *readCursor == ';')) {
        readCursor++;
      }
      if (*readCursor != '\0') {
        readCursor++;
      }
      continue;
    }
    *writeCursor++ = *readCursor++;
  }
  *writeCursor = '\0';
}

static int parseBooleanState(const char *line, const char *prefix) {
  size_t prefixLength = strlen(prefix);
  if (strncmp(line, prefix, prefixLength) != 0) {
    return -1;
  }

  const char *value = line + prefixLength;
  if (strcmp(value, "true") == 0) {
    return 1;
  }
  if (strcmp(value, "false") == 0) {
    return 0;
  }
  return -1;
}

static bool shouldLogStateChange(const char *line) {
  int *previousState = NULL;
  int newState = parseBooleanState(line, "virtual_hid_keyboard_ready ");
  if (newState >= 0) {
    previousState = &virtualKeyboardReady;
  } else {
    newState = parseBooleanState(line, "driver connected: ");
    if (newState >= 0) {
      previousState = &driverConnected;
    }
  }

  if (previousState == NULL) {
    return true;
  }

  pthread_mutex_lock(&stateLock);
  bool changed = *previousState != newState;
  *previousState = newState;
  pthread_mutex_unlock(&stateLock);
  return changed;
}

static os_log_type_t logTypeForLine(const char *line, bool isStandardError) {
  if (isStandardError || strstr(line, "[ERROR]") != NULL ||
      strstr(line, "Error:") != NULL || strstr(line, "failed") != NULL ||
      strstr(line, "panic") != NULL || strstr(line, "fatal") != NULL) {
    return OS_LOG_TYPE_ERROR;
  }
  if (strstr(line, "[WARN]") != NULL || strstr(line, "unavailable") != NULL ||
      strstr(line, "dropping ") != NULL) {
    return OS_LOG_TYPE_DEFAULT;
  }
  if (strncmp(line, "virtual_hid_keyboard_ready ", 27) == 0 ||
      strncmp(line, "driver connected: ", 18) == 0 ||
      strcmp(line, "connected") == 0 || strstr(line, "Starting kanata") != NULL ||
      strstr(line, "Input devices") != NULL ||
      strstr(line, "output backend") != NULL ||
      strstr(line, "console session") != NULL ||
      strstr(line, "keyboard grabbed") != NULL) {
    return OS_LOG_TYPE_DEFAULT;
  }
  return OS_LOG_TYPE_INFO;
}

static void *readOutput(void *argument) {
  OutputReaderContext *context = argument;
  FILE *stream = fdopen(context->fileDescriptor, "r");
  if (stream == NULL) {
    os_log_error(lifecycleLog, "Could not read Kanata output: %{public}s",
                 strerror(errno));
    close(context->fileDescriptor);
    return NULL;
  }

  char *line = NULL;
  size_t capacity = 0;
  bool skippingLayerDump = false;
  while (getline(&line, &capacity, stream) >= 0) {
    line[strcspn(line, "\r\n")] = '\0';
    stripAnsiEscapeSequences(line);

    if (strstr(line, "Entered layer:") != NULL) {
      skippingLayerDump = true;
      continue;
    }
    if (skippingLayerDump) {
      if (strcmp(line, ")") == 0) {
        skippingLayerDump = false;
      }
      continue;
    }
    if (line[0] == '\0' || !shouldLogStateChange(line)) {
      continue;
    }

    os_log_with_type(engineLog,
                     logTypeForLine(line, context->isStandardError),
                     "%{public}s", line);
  }

  free(line);
  fclose(stream);
  return NULL;
}

static void forwardSignal(int signalNumber) {
  if (childPid > 0) {
    kill((pid_t)childPid, signalNumber);
  }
}

static int runService(int argc, char *argv[]) {
  NSString *helperPath = [[[NSBundle mainBundle] bundlePath]
      stringByAppendingPathComponent:@"Contents/Helpers/kanata"];
  if (![[NSFileManager defaultManager] isExecutableFileAtPath:helperPath]) {
    os_log_error(lifecycleLog,
                 "Kanata helper is missing or not executable: %{public}s",
                 helperPath.fileSystemRepresentation);
    return 127;
  }

  char **helperArguments = calloc((size_t)argc, sizeof(char *));
  if (helperArguments == NULL) {
    os_log_error(lifecycleLog, "Could not allocate Kanata arguments");
    return 1;
  }

  helperArguments[0] = (char *)helperPath.fileSystemRepresentation;
  for (int index = 2; index < argc; index++) {
    helperArguments[index - 1] = argv[index];
  }

  int standardOutputPipe[2];
  int standardErrorPipe[2];
  if (pipe(standardOutputPipe) != 0) {
    os_log_error(lifecycleLog, "Could not create Kanata log pipes: %{public}s",
                 strerror(errno));
    free(helperArguments);
    return 1;
  }
  if (pipe(standardErrorPipe) != 0) {
    os_log_error(lifecycleLog, "Could not create Kanata log pipes: %{public}s",
                 strerror(errno));
    close(standardOutputPipe[0]);
    close(standardOutputPipe[1]);
    free(helperArguments);
    return 1;
  }

  posix_spawn_file_actions_t fileActions;
  posix_spawn_file_actions_init(&fileActions);
  posix_spawn_file_actions_addclose(&fileActions, standardOutputPipe[0]);
  posix_spawn_file_actions_adddup2(&fileActions, standardOutputPipe[1],
                                   STDOUT_FILENO);
  posix_spawn_file_actions_addclose(&fileActions, standardOutputPipe[1]);
  posix_spawn_file_actions_addclose(&fileActions, standardErrorPipe[0]);
  posix_spawn_file_actions_adddup2(&fileActions, standardErrorPipe[1],
                                   STDERR_FILENO);
  posix_spawn_file_actions_addclose(&fileActions, standardErrorPipe[1]);

  os_log(lifecycleLog, "Starting Kanata engine %{public}s",
         helperPath.fileSystemRepresentation);
  pid_t spawnedPid;
  int spawnResult = posix_spawn(&spawnedPid, helperArguments[0], &fileActions,
                                NULL, helperArguments, environ);
  posix_spawn_file_actions_destroy(&fileActions);
  free(helperArguments);
  close(standardOutputPipe[1]);
  close(standardErrorPipe[1]);
  if (spawnResult != 0) {
    close(standardOutputPipe[0]);
    close(standardErrorPipe[0]);
    os_log_error(lifecycleLog, "Could not start the Kanata helper: %{public}s",
                 strerror(spawnResult));
    return 1;
  }

  os_log(lifecycleLog, "Kanata engine started with pid %d", spawnedPid);

  OutputReaderContext standardOutputContext = {
      .fileDescriptor = standardOutputPipe[0], .isStandardError = false};
  OutputReaderContext standardErrorContext = {
      .fileDescriptor = standardErrorPipe[0], .isStandardError = true};
  pthread_t standardOutputThread;
  pthread_t standardErrorThread;
  int standardOutputThreadResult = pthread_create(
      &standardOutputThread, NULL, readOutput, &standardOutputContext);
  int standardErrorThreadResult = pthread_create(
      &standardErrorThread, NULL, readOutput, &standardErrorContext);
  if (standardOutputThreadResult != 0) {
    close(standardOutputPipe[0]);
  }
  if (standardErrorThreadResult != 0) {
    close(standardErrorPipe[0]);
  }
  if (standardOutputThreadResult != 0 || standardErrorThreadResult != 0) {
    os_log_error(lifecycleLog,
                 "Could not start Kanata output readers; stopping engine");
    kill(spawnedPid, SIGTERM);
  }

  childPid = spawnedPid;
  signal(SIGINT, forwardSignal);
  signal(SIGTERM, forwardSignal);
  signal(SIGHUP, forwardSignal);

  int status;
  while (waitpid(spawnedPid, &status, 0) == -1) {
    if (errno != EINTR) {
      os_log_error(lifecycleLog, "Could not wait for Kanata engine: %{public}s",
                   strerror(errno));
      childPid = -1;
      return 1;
    }
  }
  childPid = -1;

  if (standardOutputThreadResult == 0) {
    pthread_join(standardOutputThread, NULL);
  }
  if (standardErrorThreadResult == 0) {
    pthread_join(standardErrorThread, NULL);
  }

  if (WIFEXITED(status)) {
    int exitStatus = WEXITSTATUS(status);
    os_log_with_type(lifecycleLog,
                     exitStatus == 0 ? OS_LOG_TYPE_DEFAULT : OS_LOG_TYPE_ERROR,
                     "Kanata engine exited with status %d", exitStatus);
    return exitStatus;
  }
  if (WIFSIGNALED(status)) {
    int signalNumber = WTERMSIG(status);
    os_log(lifecycleLog, "Kanata engine terminated by signal %d", signalNumber);
    return 128 + signalNumber;
  }
  os_log_error(lifecycleLog, "Kanata engine ended with an unknown wait status");
  return 1;
}

static void openSettings(NSString *pane) {
  NSURL *url = [NSURL URLWithString:pane];
  if (url != nil) {
    [[NSWorkspace sharedWorkspace] openURL:url];
  }
}

int main(int argc, char *argv[]) {
  @autoreleasepool {
    initializeLogs();
    if (argc > 1 && strcmp(argv[1], "--run-service") == 0) {
      return runService(argc, argv);
    }

    NSApplication *application = [NSApplication sharedApplication];
    [application setActivationPolicy:NSApplicationActivationPolicyRegular];
    [application activateIgnoringOtherApps:YES];

    NSDictionary *accessibilityOptions = @{
      (__bridge NSString *)kAXTrustedCheckOptionPrompt : @YES,
    };
    BOOL accessibilityGranted =
        AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)accessibilityOptions);

    BOOL inputMonitoringGranted = CGPreflightListenEventAccess();
    if (!inputMonitoringGranted) {
      inputMonitoringGranted = CGRequestListenEventAccess();
    }

    BOOL driverInstalled = [[NSFileManager defaultManager]
        fileExistsAtPath:@"/Applications/.Karabiner-VirtualHIDDevice-Manager.app"];

    NSString *status = [NSString
        stringWithFormat:
            @"Accessibility: %@\n"
             "Input Monitoring: %@\n"
             "Karabiner virtual HID driver: %@\n\n"
             "macOS requires you to approve denied permissions in System "
             "Settings. The Kanata background service will start automatically "
             "after setup.",
            accessibilityGranted ? @"Granted" : @"Needs approval",
            inputMonitoringGranted ? @"Granted" : @"Needs approval",
            driverInstalled ? @"Installed" : @"Not installed"];

    NSAlert *alert = [[NSAlert alloc] init];
    [alert setMessageText:@"Finish setting up Kanata"];
    [alert setInformativeText:status];
    [alert setAlertStyle:NSAlertStyleInformational];
    [alert addButtonWithTitle:@"Open Input Monitoring"];
    [alert addButtonWithTitle:@"Open Accessibility"];
    [alert addButtonWithTitle:@"Open Driver Extensions"];
    [alert addButtonWithTitle:@"Done"];

    NSModalResponse response = [alert runModal];
    if (response == NSAlertFirstButtonReturn) {
      openSettings(
          @"x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent");
    } else if (response == NSAlertSecondButtonReturn) {
      openSettings(
          @"x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility");
    } else if (response == NSAlertThirdButtonReturn) {
      openSettings(
          @"x-apple.systempreferences:com.apple.LoginItems-Settings.extension");
    }
  }

  return 0;
}
