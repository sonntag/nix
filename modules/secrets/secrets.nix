{
  den.aspects.justin.homeManager = {
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
    # Let sops-nix create a device-local age identity on first activation.
    # The public recipient still has to be enrolled before a target that owns
    # encrypted secrets (currently wrath) can activate successfully.
    sops.age.generateKey = true;
    sops.age.keyFile =
      if isDarwin
      then "${home}/Library/Application Support/sops/age/keys.txt"
      else "${configHome}/sops/age/keys.txt";
  };
}
