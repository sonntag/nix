{
  config,
  inputs,
  pkgs,
  ...
}: let
  configHome = config.xdg.configHome;
  home = config.home.homeDirectory;
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  imports = [inputs.sops-nix.homeManagerModules.sops];
  sops.age.keyFile =
    if isDarwin
    then "${home}/Library/Application Support/sops/age/keys.txt"
    else "${configHome}/sops/age/keys.txt";
}
