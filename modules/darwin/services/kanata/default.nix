{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.kanata;
  driverDaemonCmd = "/Library/Application\\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
  # driverDaemonCmd = "${pkgs.karabiner-driverkit}/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
  kanataCmd = "${pkgs.kanata}/bin/kanata --nodelay --cfg ${cfg.config}";
  logPath = /Users/justin/Library/Logs/kanata;
in {
  options.services.kanata = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to enable kanata.
      '';
    };

    config = mkOption {
      type = types.path;
      default = ./kanata.kbd;
      description = ''
        Path to the config file for kanata.
      '';
    };
  };

  config = mkIf cfg.enable {
    launchd.user.agents.kanata = {
      script = ''
        sudo ${driverDaemonCmd} &
        sleep 2 &&
        sudo ${kanataCmd}
      '';
      serviceConfig = {
        Label = "org.nixos.kanata";
        RunAtLoad = true;
        StandardOutPath = logPath + "/kanata.out.log";
        StandardErrorPath = logPath + "/kanata.err.log";
        ProcessType = "Interactive";
      };
    };

    security.sudo.extraConfig = ''
      %admin ALL=(root) NOPASSWD: ${driverDaemonCmd}
      %admin ALL=(root) NOPASSWD: ${kanataCmd}
    '';

    # kmonad setup
    # follows https://github.com/mtoohey31/nixexprs/blob/main/nix-darwin/modules/mtoohey/kmonad.nix
    # echo copying shim...
    # echo will do cp --no-preserve mode ${pkgs.karabiner-daemon-shim}/bin/karabiner-daemon-shim /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim
    # # make service shim usable
    # echo will do chmod u=rwx,og= /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim
    # echo will do chown root /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim
    # system.activationScripts.applications.text = ''
    #   echo copying dext...
    #   # ${pkgs.rsync}/bin/rsync -a --delete ${pkgs.karabiner-driverkit}/.Karabiner-VirtualHIDDevice-Manager.app /Applications
    #   echo activating dext...
    #   ${pkgs.karabiner-driverkit}/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
    #   printf '\x1b[0;31mPlease grant Input Monitoring permissions to /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim in System Preferences > Security & Privacy > Privacy > Input Monitoring\x1b[0m\n'
    # '';
  };
}
