{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.karabiner-driverkit;
  parentAppDir = "/Applications/.Nix-Karabiner";
in {
  options.services.karabiner-driverkit = {
    enable = mkEnableOption "karabiner-driverkit";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [pkgs.karabiner-driverkit];

    # system.activationScripts.preActivation.text = ''
    #   rm -rf ${parentAppDir}
    #   mkdir -p ${parentAppDir}
    #   # Kernel extensions must reside inside of /Applications, they cannot be symlinks
    #   cp -r ${pkgs.karabiner-driverkit}/Applications/.Karabiner-DriverKit-VirtualHIDDevice-Manager.app ${parentAppDir}
    # '';
  };
}
