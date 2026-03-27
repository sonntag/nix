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

      environment.systemPackages = with pkgs; [
        bun
        mkcert
        wget
        yq-go
      ];

      home-manager.users.justin.imports = [../../../home/justin-greed.nix];
    };
  };
}
