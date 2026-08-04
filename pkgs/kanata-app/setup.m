#import <ApplicationServices/ApplicationServices.h>
#import <Cocoa/Cocoa.h>
#include <errno.h>
#include <signal.h>
#include <spawn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/wait.h>

extern char **environ;

static volatile sig_atomic_t childPid = -1;

static void forwardSignal(int signalNumber) {
  if (childPid > 0) {
    kill((pid_t)childPid, signalNumber);
  }
}

static int runService(int argc, char *argv[]) {
  NSString *helperPath = [[[NSBundle mainBundle] bundlePath]
      stringByAppendingPathComponent:@"Contents/Helpers/kanata"];
  if (![[NSFileManager defaultManager] isExecutableFileAtPath:helperPath]) {
    fprintf(stderr, "Kanata helper is missing or not executable: %s\n",
            helperPath.fileSystemRepresentation);
    return 127;
  }

  char **helperArguments = calloc((size_t)argc, sizeof(char *));
  if (helperArguments == NULL) {
    perror("calloc");
    return 1;
  }

  helperArguments[0] = (char *)helperPath.fileSystemRepresentation;
  for (int index = 2; index < argc; index++) {
    helperArguments[index - 1] = argv[index];
  }

  pid_t spawnedPid;
  int spawnResult =
      posix_spawn(&spawnedPid, helperArguments[0], NULL, NULL, helperArguments,
                  environ);
  free(helperArguments);
  if (spawnResult != 0) {
    fprintf(stderr, "Could not start the Kanata helper: %s\n",
            strerror(spawnResult));
    return 1;
  }

  childPid = spawnedPid;
  signal(SIGINT, forwardSignal);
  signal(SIGTERM, forwardSignal);
  signal(SIGHUP, forwardSignal);

  int status;
  while (waitpid(spawnedPid, &status, 0) == -1) {
    if (errno != EINTR) {
      perror("waitpid");
      childPid = -1;
      return 1;
    }
  }
  childPid = -1;

  if (WIFEXITED(status)) {
    return WEXITSTATUS(status);
  }
  if (WIFSIGNALED(status)) {
    return 128 + WTERMSIG(status);
  }
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
