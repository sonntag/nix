{
  pkgs,
  inputs,
  ...
}: {
  programs.tmux = rec {
    enable = true;

    # sensible is no longer maintained and breaks having tmux open with the configured
    # shell. It's on by default but will be off by default in the next home-manager release
    # Setting to false for now but can remove later.
    # https://github.com/nix-community/home-manager/issues/5952
    sensibleOnTop = false;

    baseIndex = 1;
    prefix = "C-b";
    keyMode = "vi";
    mouse = true;
    terminal = "$TERM";
    shell = "$SHELL";
    resizeAmount = 5;

    # Copied from sensible
    escapeTime = 0;
    historyLimit = 50000;
    aggressiveResize = true;

    extraConfig = ''
      # Options
      #set -as terminal-features "$TERM:RGB" # 24-bit color

      set -g renumber-windows on # Renumber windows when a window is closed
      set -g detach-on-destroy off # Don't exit from tmux when closing a session
      #set -g set-clipboard on # Use system clipboard

      # Copied from sensible
      set -g display-time 4000
      set -g status-interval 5
      set -g status-keys emacs
      set -g focus-events on
      bind b last-window
      bind C-p previous-window
      bind C-n next-window

      # Appearance
      set -g status-position top

      # Copy Mode
      #bind-key -T copy-mode-vi v send-keys -X begin-selection
      #bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle

      # Reload Tmux config
      bind R source-file ~/.config/tmux/tmux.conf \; display "Tmux config reloaded!"

      # Split windows
      #unbind %
      #bind | split-window -h -c "#{pane_current_path}"
      #unbind '"'
      #bind - split-window -v -c "#{pane_current_path}"

      # Resize windows
      #unbind Right
      #bind -r Right resize-pane -R ${toString resizeAmount}
      #unbind Left
      #bind -r Left resize-pane -L ${toString resizeAmount}
      #unbind Up
      #bind -r Up resize-pane -U ${toString resizeAmount}
      #unbind Down
      #bind -r Down resize-pane -D ${toString resizeAmount}
      #unbind z
      #bind -r Space resize-pane -Z
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
      # {
      #   plugin = inputs.tmux-sessionx.packages.${pkgs.system}.default;
      #   extraConfig = ''
      #     unbind o
      #     set -g @sessionx-bind 'o'
      #     set -g @sessionx-window-height '85%'
      #     set -g @sessionx-window-width '75%'
      #     set -g @sessionx-zoxide-mode 'on'
      #   '';
      # }
      tmuxPlugins.resurrect
      # TODO: re-enable this once I fix vim-tmux-navigator
      # tmuxPlugins.vim-tmux-navigator
    ];
  };
}
