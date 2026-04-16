{den, ...}: {
  den.aspects.wrath = {
    includes = [
      den.provides.hostname
      den.aspects.personal
      den.aspects.auto-update
    ];
    darwin = {
      nix-homebrew.user = "justin";
      services.tailscale.enable = true;

      home-manager.users.justin.imports = [../../users/justin/_personal.nix];
    };
  };
}
