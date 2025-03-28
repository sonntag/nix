{pkgs, ...}: {
  sonntag.nix.enable = true;

  environment.systemPackages = with pkgs; [
    awscli2
    azure-cli
    kubelogin
    mkcert
    wget
    yq-go
  ];

  imports = [
    ./users.nix
    ./casks.nix
    ./dock.nix
  ];
}
