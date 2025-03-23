{pkgs, ...}: let
  userName = "justin";
  userHome = "/Users/${userName}";
in {
  nix.settings.trusted-users = [userName];

  users.users.${userName} = {
    name = userName;
    home = userHome;
    shell = pkgs.fish;
  };

  home-manager.users.${userName}.imports = [../../home/justin-wrath.nix];

  nix-homebrew.user = userName;
}
