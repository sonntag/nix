{den, ...}: {
  den.aspects.wrath = {
    includes = [
      den.provides.hostname
      den.aspects.auto-update
      den.aspects.personal
    ];
    darwin = {
      nix-homebrew.user = "justin";
      services.tailscale.enable = true;
    };
  };
}
