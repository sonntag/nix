{
  den.default.darwin.programs.fish.enable = true;
  den.aspects.justin.homeManager = {pkgs, ...}: let
    #inherit (config.home.user-info) nixConfigDirectory;
    nixConfigDirectory = "/Users/justin/Development/sonntag/nix";
  in {
    programs.fish = {
      enable = true;

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
        du = "${dust}/bin/dust";
        g = "${git}/bin/git";
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
          # Start/attach to a tmux session if not already attached.
          # Only auto-tmux when running in Ghostty to keep other terminals (e.g. Codex Desktop) tmux-free.
          if not set -q TMUX
            set -l term_program (string lower -- "$TERM_PROGRAM")
            if test "$term_program" = "ghostty"
              tmux-attach-or-create
            end
          end

          # Enable vi keybindings
          fish_vi_key_bindings

          # Disable welcome message
          set fish_greeting
        '';
    };
  };
}
