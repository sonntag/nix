{den, ...}: {
  den.aspects.greed = {
    includes = [
      den.provides.hostname
      den.aspects.amperity
    ];
    darwin = {pkgs, ...}: {
      nix-homebrew.user = "justin";
      sonntag.nix.trusted-users = ["root" "@admin" "justin"];
      sonntag.system.auto-update.enable = false;
      sonntag.darwin.personal-casks.enable = false;

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
