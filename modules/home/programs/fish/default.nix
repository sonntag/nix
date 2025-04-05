{pkgs, ...}: let
  #inherit (config.home.user-info) nixConfigDirectory;
  nixConfigDirectory = "/Users/justin/.config/nix";
in {
  imports = [
    ./shell-colors.nix
    ./sponge.nix
  ];

  programs.fish = {
    enable = true;

    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        src = autopair.src;
      }
      # {
      #   name = "babelfish";
      #   src = pkgs.babelfish;
      # }
      # {
      #   name = "bass";
      #   src = bass.src;
      # }
      {
        name = "clownfish";
        src = clownfish.src;
      }
      {
        name = "done";
        src = done.src;
      }
      {
        name = "fzf-fish";
        src = fzf-fish.src;
      }
      {
        name = "puffer";
        src = puffer.src;
      }
    ];

    functions = {
      clear-dns-cache.body = ''
        sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder $argv
      '';

      cx.body = ''
        cd $argv && eza -l
      '';

      cxa.body = ''
        cd $argv && eza -la
      '';

      starship_transient_prompt_func.body = ''
        starship module character
      '';

      starship_transient_rprompt_func.body = ''
        starship module time
      '';

      kickstart-kanata.body = ''
        launchctl kickstart -k gui/$(id -u)/org.nixos.kanata
      '';

      tmux-attach-or-create.body =
        /*
        fish
        */
        ''
          set most_recent (tmux list-sessions -f "#{?session_attached,,#{!=:#{session_name},kanata}}" -F "#{session_name},#{session_last_attached}" | \
              string split '\n' | \
              sort -r -t ',' -k2 | \
              head -n 1 | \
              string split ',' | \
              head -n 1)

          if test -n "$most_recent"
              tmux attach-session -t $most_recent
          else
              tmux new-session
          end
        '';
    };

    shellAliases = with pkgs; {
      # Nix related
      drb = "darwin-rebuild build --flake ${nixConfigDirectory}";
      drs = "darwin-rebuild switch --flake ${nixConfigDirectory}";
      flakeup = "nix flake update --flake ${nixConfigDirectory}";
      # nb = "nix build";
      # nd = "nix develop";
      # nf = "nix flake";
      # nr = "nix run";
      # ns = "nix search";

      # Other
      cat = "${bat}/bin/bat";
      du = "${du-dust}/bin/dust";
      g = "${gitAndTools.git}/bin/git";
      l = "ll --all";
      ll = "ls -l --icons";
      ld = "ll | grep ^d";
      ls = "${eza}/bin/eza";
      hh = "ll";
      hu = "ls";
      huh = "l";
      hud = "ld";
      ps = "${procs}/bin/procs";
    };

    # # FIXME: This is needed to address bug where the $PATH is re-ordered by
    # # the `path_helper` tool, prioritising Apple’s tools over the ones we’ve
    # # installed with nix.
    # #
    # # This gist explains the issue in more detail: https://gist.github.com/Linerre/f11ad4a6a934dcf01ee8415c9457e7b2
    # # There is also an issue open for nix-darwin: https://github.com/LnL7/nix-darwin/issues/122
    # shellInit = let
    #   # We should probably use `config.environment.profiles`, as described in
    #   # https://github.com/LnL7/nix-darwin/issues/122#issuecomment-1659465635
    #   # but this takes into account the new XDG paths used when the nix
    #   # configuration has `use-xdg-base-directories` enabled. See:
    #   # https://github.com/LnL7/nix-darwin/issues/947 for more information.
    #   profiles = [
    #     "/etc/profiles/per-user/$USER" # Home manager packages
    #     "$HOME/.nix-profile"
    #     "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo $HOME/.local/state)/nix/profile"
    #     "/run/current-system/sw"
    #     "/nix/var/nix/profiles/default"
    #   ];
    #
    #   makeBinSearchPath =
    #     lib.concatMapStringsSep " " (path: "${path}/bin");
    # in ''
    #   # Fix path that was re-ordered by Apple's path_helper
    #   fish_add_path --move --prepend --path ${makeBinSearchPath profiles}
    #   set fish_user_paths $fish_user_paths
    # '';

    interactiveShellInit =
      /*
      fish
      */
      ''
        # Start/attach to a tmux session if not already attached
        if not set -q TMUX
          tmux-attach-or-create
        end

        # Enable vi keybindings
        fish_vi_key_bindings

        # Disable welcome message
        set fish_greeting
      '';
  };
}
