{pkgs, ...}: {
  sonntag.darwin.personal-casks.enable = false;

  environment.systemPackages = with pkgs; [
    mkcert
    wget
    yq-go
  ];

  imports = [
    ./users.nix
    ./casks.nix
  ];
}
