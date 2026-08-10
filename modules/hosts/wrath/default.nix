{den, ...}: {
  den.aspects.wrath = {
    includes = [
      den.provides.hostname
      den.aspects.auto-update
      den.aspects.personal
      den.aspects.macwhisper
    ];
    darwin = {
      nix-homebrew.user = "justin";
    };
  };
}
