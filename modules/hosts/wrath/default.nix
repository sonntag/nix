{den, ...}: {
  den.aspects.wrath = {
    includes = [den.provides.hostname];
    darwin = {
      nix-homebrew.user = "justin";
      sonntag.system.auto-update.enable = true;
      services.tailscale.enable = true;

      home-manager.users.justin.imports = [../../../home/justin-wrath.nix];
    };
  };
}
