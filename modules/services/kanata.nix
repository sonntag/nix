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
    services.kanata = {
      enable = mkEnableOption "kanata";

      config = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      myKanata
    ];

    # configuration file
    environment.etc."kanata.cfg".text = cfg.config;

    system.activationScripts.postActivation.text = ''
      echo "attempt to activate Kanata system extension and start daemons" >&2
      launchctl unload /Library/LaunchDaemons/org.nixos.kanata.plist
      launchctl load /Library/LaunchDaemons/org.nixos.kanata.plist
    '';

    launchd.daemons.kanata = {
      script = ''
        sudo ${pkgs.myKanata}/bin/kanata -c /etc/kanata.cfg
      '';
      serviceConfig = {
        Label = "org.nixos.kanata";
        RunAtLoad = true;
        KeepAlive = true;
        StandardOutPath = "/Library/Logs/Kanata/kanata.out.log";
        StandardErrorPath = "/Library/Logs/Kanata/kanata.err.log";
      };
    };

    environment.etc."sudoers.d/kanata".source = pkgs.runCommand "sudoers-kanata" {} ''
      KANATA_BIN="${pkgs.myKanata}/bin/kanata"
      SHASUM=$(sha256sum "$KANATA_BIN" | cut -d' ' -f1)
      cat <<EOF >"$out"
      %admin ALL=(root) NOPASSWD: sha256:$SHASUM $KANATA_BIN
      EOF
    '';
  };
}
