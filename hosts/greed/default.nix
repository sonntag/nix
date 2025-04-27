{pkgs, ...}: {
  sonntag.darwin.personal-casks.enable = false;

  environment.systemPackages = with pkgs; [
    awscli2
    azure-cli
    jet
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
