{pkgs, ...}: {
  system.stateVersion = 5;

  environment.systemPackages = with pkgs; [
    awscli2
    azure-cli
    kubelogin
    mkcert
  ];

  imports = [
    ./users.nix
    ./casks.nix
    ./dock.nix
    ../../modules/darwin/system/nix.nix
    ../../modules/darwin/system/homebrew.nix
    ../../modules/darwin/system/security.nix
    ../../modules/darwin/system/home-manager.nix
    ../../modules/darwin/system/settings.nix
    # ../../modules/darwin/services/aerospace.nix
    # ../../modules/darwin/services/jankyborders.nix
    ../../modules/darwin/services/nix-daemon.nix
    # ../../modules/darwin/services/sketchybar
    ../../modules/darwin/programs/casks.nix
    ../../modules/darwin/programs/ghostty
    ../../modules/darwin/programs/mas.nix
    # ../../modules/nixos/programs/zsh.nix
  ];
}
