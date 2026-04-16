{den, ...}: {
  den.aspects.greed = {
    includes = [
      den.provides.hostname
      den.aspects.amperity
      den.aspects.work
    ];
    darwin = {pkgs, ...}: {
      nix-homebrew.user = "justin";
      sonntag.nix.trusted-users = ["root" "@admin" "justin"];
      sonntag.darwin.personal-casks.enable = false;

      environment.systemPackages = with pkgs; [
        bun
        mkcert
        wget
        yq-go
      ];
    };
  };
}
