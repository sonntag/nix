{pkgs, ...}: {
  home.packages = with pkgs; [
    fabric-ai
  ];
}
