{...}: let
  driverDaemonCmd = "/Library/Application\\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
  kanataCmd = "/Users/justin/Downloads/kanata_macos_arm64 --cfg ${./kanata.kbd}";
  logPath = /Users/justin/.log/kanata;
in {
  launchd.user.agents.kanata = {
    script = ''
      sudo ${driverDaemonCmd} &
      sleep 2 && sudo ${kanataCmd}
    '';
    serviceConfig = {
      Label = "org.nixos.kanata";
      RunAtLoad = true;
      StandardErrorPath = logPath + /err.log;
      StandardOutPath = logPath + /out.log;
      ProcessType = "Interactive";
    };
  };

  security.sudo.extraConfig = ''
    %admin ALL=(root) NOPASSWD: ${driverDaemonCmd}
    %admin ALL=(root) NOPASSWD: ${kanataCmd}
  '';
}
