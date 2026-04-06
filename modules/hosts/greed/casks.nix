{inputs, ...}: {
  den.aspects.greed.darwin = {
    nix-homebrew.taps = with inputs; {
      "conductorone/homebrew-cone" = homebrew-cone;
      "hashicorp/homebrew-tap" = homebrew-hashicorp;
    };

    homebrew.casks = [
      "sublime-text"
      "tableplus"
    ];
  };
}
