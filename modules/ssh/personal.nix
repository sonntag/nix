{
  den.aspects.personal.homeManager = {
    lib,
    pkgs,
    ...
  }: {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "github.com" =
          {
            HostName = "github.com";
            AddKeysToAgent = "yes";
            # The private key is generated locally by `nix run .#setup-ssh`.
            # Nix manages how it is used, but never owns the key material.
            IdentityFile = "~/.ssh/id_ed25519";
          }
          // lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
            UseKeychain = "yes";
          };
      };
    };
  };
}
