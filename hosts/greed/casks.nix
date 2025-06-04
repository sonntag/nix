{inputs, ...}: {
  nix-homebrew = {
    taps = with inputs; {
      "conductorone/homebrew-cone" = homebrew-cone;
      "hashicorp/homebrew-tap" = homebrew-hashicorp;
    };
  };

  homebrew.casks = [
    "chatbox"
    "chatwise"
    "sublime-text"
    "tableplus"
  ];
}
