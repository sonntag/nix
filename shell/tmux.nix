{
  pkgs,
  inputs,
  ...
}: {
  programs.tmux = {
    enable = true;

    baseIndex = 1;
    prefix = "C-b";
    keyMode = "vi";
    mouse = true;
    terminal = "tmux-256color";

    extraConfig = ''
      set -g status-position top
    '';

    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.better-mouse-mode;
        extraConfig = ''
          set -g @scroll-without-changing-pane 'on'
          set -g @scroll-in-moused-over-pane 'on'
          set -g @emulate-scroll-for-no-mouse-alternate-buffer 'on'
        '';
      }
      {
        plugin = tmuxPlugins.continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
      {
        plugin = tmuxPlugins.rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'main'
          set -g @rose_pine_host 'on'
          set -g @rose_pine_directory 'on'
        '';
      }
      {
        plugin = inputs.tmux-sessionx.packages.${pkgs.system}.default;
        extraConfig = ''
          unbind o
          set -g @sessionx-bind 'o'
          set -g @sessionx-window-height '85%'
          set -g @sessionx-window-width '75%'
          set -g @sessionx-zoxide-mode 'on'
        '';
      }
      tmuxPlugins.resurrect
      tmuxPlugins.sensible
      tmuxPlugins.vim-tmux-navigator
    ];
  };
}
