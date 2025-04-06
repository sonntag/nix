{pkgs, ...}: {
  nix.enable = false;

  sonntag.darwin.personal-casks.enable = false;

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
