{pkgs, ...}: {
  sonntag.nix.enable = true;

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
