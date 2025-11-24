{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.ssh;
in {
  options.sonntag.ssh.profile = mkOption {
    type = types.enum ["personal" "work"];
    default = "personal";
    description = "ssh profile to apply.";
  };
  imports = [
    ./personal
    ./work
  ];
}
