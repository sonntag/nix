{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    awscli2
    azure-cli
    jet
    kubelogin
  ];

  imports = [
    ./homebrew.nix
  ];
}
