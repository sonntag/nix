{pkgs, ...}: let
  userName = "justin";
  userHome = "/Users/${userName}";
in {
  # TODO: figure out how to set trusted-users properly for determinate-nix.
  # Currently I have this set manually
  # nix.settings.trusted-users = [
  #   "root"
  #   "@admin"
  #   userName
  # ];

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
