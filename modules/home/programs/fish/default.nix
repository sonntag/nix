{pkgs, ...}: let
  #inherit (config.home.user-info) nixConfigDirectory;
  nixConfigDirectory = "/Users/justin/Development/sonntag/nix";
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
      # TODO: Can this be moved to nix-darwin or does it have to be configured in home-manager?
      {
        name = "foreign-env";
        src = foreign-env.src;
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
      drs = "sudo darwin-rebuild switch --flake ${nixConfigDirectory}";
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
