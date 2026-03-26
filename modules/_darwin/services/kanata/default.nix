{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.kanata;
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
    environment.systemPackages = with pkgs; [
      kanata
    ];

    environment.shellAliases = {
      kickstart-kanata = "sudo launchctl kickstart -k system/org.nixos.kanata";
    };

    launchd.daemons = {
      kanata = {
        command = "${pkgs.kanata}/bin/kanata --nodelay -c ${cfg.config}";
        serviceConfig = {
          RunAtLoad = true;
          KeepAlive = true;
          StandardErrorPath = "/Library/Logs/Kanata/kanata.err.log";
          StandardOutPath = "/Library/Logs/Kanata/kanata.out.log";
        };
      };
      karabiner-vhiddaemon = {
        command = "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
        serviceConfig = {
          ProgramArguments = [
            "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"
          ];
          RunAtLoad = true;
          KeepAlive = true;
        };
      };
      karabiner-vhidmanager = {
        command = "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate";
        serviceConfig = {
          ProgramArguments = [
            "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"
            "activate"
          ];
          RunAtLoad = true;
        };
      };
    };

    # kmonad setup
    # follows https://github.com/mtoohey31/nixexprs/blob/main/nix-darwin/modules/mtoohey/kmonad.nix
    # echo copying shim...
    # echo will do cp --no-preserve mode ${pkgs.karabiner-daemon-shim}/bin/karabiner-daemon-shim /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim
    # # make service shim usable
    # echo will do chmod u=rwx,og= /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim
    # echo will do chown root /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim
    # system.activationScripts.applications.text = ''
    #   echo copying dext...
    #   ${pkgs.rsync}/bin/rsync -a --delete ${pkgs.karabiner-driverkit}/.Karabiner-VirtualHIDDevice-Manager.app /Applications
    #   touch /Applications/.Kara
    #   echo activating dext...
    #   /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
    #   printf '\x1b[0;31mPlease grant Input Monitoring permissions to /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim in System Preferences > Security & Privacy > Privacy > Input Monitoring\x1b[0m\n'
    # '';
  };
}
