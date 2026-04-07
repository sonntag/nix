{pkgs, ...}: {
  # sonntag.programs.nixvim.enable = true;
  darwin.wallpaper.image.path = ../../../backgrounds/rose-pine/rose_pine_shape.png;

  home.packages = with pkgs; [
    clojure
  ];

  sonntag.services.ollama.enable = true;
}
