{pkgs, ...}: {
  imports = [
    ../modules/home
  ];
  sonntag.programs.nvim.enable = true;
  # sonntag.programs.nixvim.enable = true;
  darwin.wallpaper.image.path = ../backgrounds/rose-pine/rose_pine_shape.png;

  home.packages = with pkgs; [
    clojure
  ];
}
