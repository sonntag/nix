{
  inputs,
  pkgs,
  config,
  ...
}: let
  configHome = config.xdg.configHome;
  home = config.home.homeDirectory;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  imports = [inputs.sops-nix.homeManagerModules.sops];
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
}
