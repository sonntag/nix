{...}: {
  nix = {
    settings = {
      # trusted-users = ["@staff"];

      # substituters = [
      #   "https://nix-community.cachix.org"
      # ];

      # trusted-public-keys = [
      #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      # ];

      experimental-features = "nix-command flakes";
    };

    # gc = {
    #   automatic = true;
    #   interval.Day = 7;
    #   options = "--delete-older-than 7d";
    # };
    #
    # optimise = {
    #   automatic = true;
    #   interval.Day = 7;
    # };
  };
}
