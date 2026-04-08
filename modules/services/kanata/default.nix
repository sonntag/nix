{
  den.default.darwin = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      kanata
    ];

    environment.shellAliases = {
      kickstart-kanata = "sudo launchctl kickstart -k system/org.nixos.kanata";
    };

    launchd.daemons = {
      kanata = {
        command = "${pkgs.kanata}/bin/kanata --nodelay -c ${./kanata.kbd}";
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
  };
}
