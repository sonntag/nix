{pkgs, ...}: let
  driverDaemonCmd = "/Library/Application\\ Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";
  kanataCmd = "${pkgs.kanata}/bin/kanata --cfg ${./kanata.kbd}";
  logPath = /Users/justin/Library/Logs/kanata;
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

  # kmonad setup
  # follows https://github.com/mtoohey31/nixexprs/blob/main/nix-darwin/modules/mtoohey/kmonad.nix
  # system.activationScripts.applications.text = pkgs.lib.mkForce ''
  #   echo copying dext...
  #   echo will do ${pkgs.rsync}/bin/rsync -a --delete ${pkgs.karabiner-driverkit}/Applications/.Karabiner-VirtualHIDDevice-Manager.app /Applications
  #   echo copying shim...
  #   echo will do cp --no-preserve mode ${pkgs.karabiner-daemon-shim}/bin/karabiner-daemon-shim /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim
  #   # make service shim usable
  #   echo will do chmod u=rwx,og= /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim
  #   echo will do chown root /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim
  #   echo activating dext...
  #   echo will do /Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager activate
  #   printf '\x1b[0;31mPlease grant Input Monitoring permissions to /Applications/.Karabiner-VirtualHIDDevice-Manager.app/karabiner-daemon-shim in System Preferences > Security & Privacy > Privacy > Input Monitoring\x1b[0m\n'
  # '';
}
