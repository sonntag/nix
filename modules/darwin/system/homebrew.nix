{
  config,
  inputs,
  ...
}: let
  inherit (inputs) nix-homebrew;
in {
  imports = [nix-homebrew.darwinModules.nix-homebrew];

  homebrew = {
    enable = true;

    caskArgs.no_quarantine = true;

    # nix-homebrew is handling homebrew updates
    global.autoUpdate = false;

    onActivation = {
      # "zap" removes manually installed brews and casks
      cleanup = "zap";
      # nix-homebrew is handling homebrew updates
      autoUpdate = false;
      upgrade = true;
    };

    # https://github.com/zhaofengli/nix-homebrew/issues/5
    taps = builtins.attrNames config.nix-homebrew.taps;
  };

  nix-homebrew = {
    enable = true;
    autoMigrate = true;
    enableRosetta = false;
    mutableTaps = false;
    taps = with inputs; {
      "homebrew/homebrew-core" = homebrew-core;
      "homebrew/homebrew-cask" = homebrew-cask;
      "nikitabobko/homebrew-tap" = homebrew-nikitabobko;
    };
  };
}
