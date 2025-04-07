{pkgs, ...}: let
  userName = "justin";
  userHome = "/Users/${userName}";
in {
  users.knownUsers = [userName];

  users.users.${userName} = {
    uid = 501;
    name = userName;
    home = userHome;
    shell = pkgs.fish;
  };

  home-manager.users.${userName}.imports = [../../home/justin-greed.nix];

  nix-homebrew.user = userName;
}
