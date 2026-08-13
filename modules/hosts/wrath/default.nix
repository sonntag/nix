{den, ...}: {
  den.aspects.wrath = {
    includes = [
      den.batteries.hostname
      den.aspects.auto-update
      den.aspects.personal
      den.aspects.macwhisper
      den.aspects.voiceink
    ];
    darwin.nix-homebrew.user = "justin";
  };
}
