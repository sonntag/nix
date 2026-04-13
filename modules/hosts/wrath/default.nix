{den, ...}: {
  den.aspects.wrath = {
    includes = [
      den.provides.hostname
      den.aspects.personal
    ];
    darwin = {
      nix-homebrew.user = "justin";
      sonntag.system.auto-update.enable = true;
      services.tailscale.enable = true;

      home-manager.users.justin.imports = [../../users/justin/_personal.nix];
    };
  };
}
