{den, ...}: {
  den.aspects.wrath = {
    includes = [den.provides.hostname];
    darwin = {
      nix-homebrew.user = "justin";
      sonntag.system.auto-update.enable = true;
      services.tailscale.enable = true;
      sonntag.services.aerospace.enable = true;
      sonntag.services.kanata.enable = true;

      home-manager.users.justin.imports = [../../users/justin/_personal.nix];
    };
  };
}
