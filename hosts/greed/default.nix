{pkgs, ...}: {
  system.stateVersion = 5;

  environment.systemPackages = with pkgs; [
    awscli2
    azure-cli
    kubelogin
    mkcert
    wget
    yq-go
  ];

  system.wallpaper.image.path = ../../backgrounds/rancho-cucamonga-tree.png;

  imports = [
    ./users.nix
    ./casks.nix
    ./dock.nix
    # ../../modules/darwin/services/aerospace.nix
    # ../../modules/darwin/services/jankyborders.nix
    # ../../modules/darwin/services/sketchybar
  ];
}
