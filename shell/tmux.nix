{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    prefix = "C-b";
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";

    plugins = with pkgs; [
      # tmuxPlugins.better-mouse-mode
      tmuxPlugins.sensible
      tmuxPlugins.rose-pine
      tmuxPlugins.vim-tmux-navigator
    ];

    extraConfig = ''
      # Position status bar on top
      set -g status-position top

      # Theme setup
      set -g @rose_pine_variant 'main'
      set -g @rose_pine_host 'on'
      set -g @rose_pine_directory 'on'
    '';
  };
}
