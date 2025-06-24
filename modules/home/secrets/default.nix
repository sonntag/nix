{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.secrets;
  configHome = config.xdg.configHome;
  home = config.home.homeDirectory;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  options.sonntag.secrets.enable = mkEnableOption "secrets";
  imports = [inputs.sops-nix.homeManagerModules.sops];
  config = mkIf cfg.enable {
    sops = {
      age.keyFile =
        if isDarwin
        then "${home}/Library/Application Support/sops/age/keys.txt"
        else "${configHome}/sops/age/keys.txt";
      secrets = {
        ".ssh/id_justin" = {
          sopsFile = ./ssh/justin.personal.yaml;
          key = "private-key";
          path = "${home}/.ssh/id_justin";
        };
      };
    };

    home.file = {
      "./.ssh/id_justin.pub".source = ./ssh/justin.pub;
      "./.ssh/config".source = ./ssh/config;
    };
  };
}
