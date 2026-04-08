{den, ...}: {
  den.aspects.greed = {
    includes = [den.provides.hostname];
    darwin = {pkgs, ...}: {
      nix-homebrew.user = "justin";
      sonntag.nix.trusted-users = ["root" "@admin" "justin"];
      sonntag.system.auto-update.enable = false;
      sonntag.darwin.personal-casks.enable = false;
      sonntag.secrets.enable = true;
      amperity.enable = true;
      sonntag.services.aerospace.enable = true;
      sonntag.services.kanata.enable = true;

      environment.systemPackages = with pkgs; [
        bun
        mkcert
        wget
        yq-go
      ];

      home-manager.users.justin.imports = [../../users/justin/_work.nix];
    };
  };
}
