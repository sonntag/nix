{den, ...}: {
  den.aspects.greed = {
    includes = [
      den.provides.hostname
      den.aspects.amperity
    ];
    darwin = {pkgs, ...}: {
      nix-homebrew.user = "justin";
      sonntag.nix.trusted-users = ["root" "@admin" "justin"];

      environment.systemPackages = with pkgs; [
        bun
        mkcert
        wget
        yq-go
      ];
    };
  };
}
