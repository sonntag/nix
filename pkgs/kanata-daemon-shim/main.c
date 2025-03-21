#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

char *const kdv_client[] = {"@client@"};

int main(int argc, char *argv[]) {
  int r = fork();
  if (r < 0) {
    perror("kanata-service-shim: fork");
    return 1;
  } else if (r == 0) {
    r = execvp(kdv_client[0], kdv_client);
  } else {
    // To give time for kdv-client to start
    sleep(1);
    r = execvp("kanata", argv);
  };
  if (r < 0) {
    perror("kanata-service-shim: execvp");
    return 1;
  }
}
