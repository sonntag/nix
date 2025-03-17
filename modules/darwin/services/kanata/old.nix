{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.services.kanata;
in {
  options = {
    services.kanata.enable = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether te enable kanata.
      '';
    };

    services.kanata.config = mkOption {
      type = types.path;
      default = ./kanata.kbd;
      description = ''
        Path to the config file for kanata.
      '';
    };
  };

  config = mkIf cfg.enable {
    # system.activationScripts.postActivation.text = ''
    #   echo "attempt to activate Kanata system extension and start daemons" >&2
    #   launchctl unload /Library/LaunchDaemons/org.nixos.kanata.plist
    #   launchctl load /Library/LaunchDaemons/org.nixos.kanata.plist
    # '';

    launchd.user.agents.kanata = {
      script = ''
        sudo ${pkgs.kanata}/bin/kanata -c ${cfg.config}
      '';
      serviceConfig = {
        Label = "org.nixos.kanata";
        RunAtLoad = true;
        KeepAlive = false;
        StandardOutPath = "/Users/justin/.logs/kanata/kanata.out.log";
        StandardErrorPath = "/Users/justin/.logs/kanata/kanata.err.log";
        ProcessType = "Interactive";
      };
    };

    environment.etc."sudoers.d/kanata".source = pkgs.runCommand "sudoers-kanata" {} ''
      KANATA_BIN="${pkgs.kanata}/bin/kanata"
      SHASUM=$(sha256sum "$KANATA_BIN" | cut -d' ' -f1)
      cat <<EOF >"$out"
      %admin ALL=(root) NOPASSWD: sha256:$SHASUM $KANATA_BIN
      EOF
    '';
  };
}
