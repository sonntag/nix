{pkgs, ...}: {
  sonntag.system.auto-update.enable = true;
  sonntag.darwin.personal-casks.enable = false;
  amperity.enable = true;

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
