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
      # tmuxPlugins.better-mouse-mode
      {
        plugin = tmuxPlugins.rose-pine;
        extraConfig = ''
          set -g @rose_pine_variant 'main'
          set -g @rose_pine_host 'on'
          set -g @rose_pine_directory 'on'
        '';
      }
      tmuxPlugins.sensible
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
      tmuxPlugins.vim-tmux-navigator
    ];
  };
}
