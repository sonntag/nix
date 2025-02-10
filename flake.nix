{
  description = "Justin's nix config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Darwin related stuff
    nix-darwin = {
      url = "github:LnL7/nix-darwin/nix-darwin-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew = {
      url = "github:zhaofengli/nix-homebrew";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-darwin.follows = "nix-darwin";
    };

    # Homebrew taps
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    homebrew-services = {
      url = "github:homebrew/homebrew-services";
      flake = false;
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    cone-tap = {
      url = "github:conductorone/homebrew-cone";
      flake = false;
    };
    nikitabobko-tap = {
      # Contains aerospace
      url = "github:nikitabobko/homebrew-tap";
      flake = false;
    };

    tmux-sessionx.url = "github:omerxx/tmux-sessionx";

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
    nix-homebrew,
    homebrew-core,
    homebrew-cask,
    homebrew-services,
    homebrew-bundle,
    cone-tap,
    nikitabobko-tap,
    ...
  }: let
    user = "justin";
    system = "aarch64-darwin";

    # greedInfo = {
    #   user = "justin";
    #   system = "aarch64-darwin";
    #   fullUser = "Justin Sonntag";
    #   email = "sonntag@amperity.com";
    #   nixConfigDirectory = "/Users/justin/.config/nix";
    # };

    configuration = {pkgs, ...}: {
      imports = [
        ./darwin/dock.nix
        ./darwin/homebrew.nix
        ./darwin/touch-id.nix
      ];

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.sketchybar
      ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # services.kanata = {
      #   enable = true;
      #   config = builtins.readFile ./kanata/kanata.kbd;
      # };

      # Allow touch-id for sudo
      #security.pam.enableSudoTouchIdAuth = true;
      security.pam.enableSudoTouchId = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh.enable = true; # default shell on catalina
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      system.defaults = {
        dock = {
          autohide = true;
          autohide-delay = 0.1;
          autohide-time-modifier = 0.5;
          expose-animation-duration = 0.25;
          expose-group-apps = true;
          launchanim = false;
          mineffect = "scale";
          minimize-to-application = true;
          mouse-over-hilite-stack = true;
          mru-spaces = false;
          orientation = "bottom";
          # persistent-apps = [
          #   "/System/Applications/Messages.app"
          #   "/Applications/Arc.app"
          #   "/Applications/Spark Desktop.app"
          #   "/Applications/Things3.app"
          #   "/Applications/Obsidian.app"
          #   "/Applications/Slack.app"
          #   "/System/Applications/Calendar.app"
          #   "/Applications/Ghostty.app"
          #   "/Applications/ChatGPT.app"
          #   "/Applications/OpenSCAD.app"
          # ];
          #
          # persistent-others = [
          #   "/Users/${user}/Desktop"
          #   "/Users/${user}/Downloads"
          # ];

          # CustomUserPreferences = {
          #         # Sets Downloads folder with fan view in Dock
          #         "com.apple.dock" = {
          #             persistent-others = [
          #             {
          #                 "tile-data" = {
          #                     "file-data" = {
          #                     "_CFURLString" = "/Users/<youruser>/Downloads";
          #                     "_CFURLStringType" = 0;
          #                   };
          #                   "arrangement" = 2;  # sorting order
          #                   "displayas" = 1;    # 1 for fan display
          #                   "showas" = 1;       # 1 for stack view
          #                 };
          #                 "tile-type" = "directory-tile";
          #               }
          #             {
          #                 "tile-data" = {
          #                   "file-data" = {
          #                     "_CFURLString" = "/Applications";
          #                     "_CFURLStringType" = 0;
          #                   };
          #                 };
          #                 "tile-type" = "directory-tile";
          #               }
          #           ];
          #         };
          #       };
          #
          #   };

          show-process-indicators = true;
          show-recents = true;
          showhidden = true;

          slow-motion-allowed = false;

          static-only = false;

          tilesize = 42;
        };

        spaces.spans-displays = true;
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = system;
      nixpkgs.config.allowUnfree = true;
      nixpkgs.overlays = [
        (import ./overlays/default.nix)
      ];

      environment.shells = [pkgs.fish];

      users.users.${user} = {
        name = "${user}";
        home = "/Users/${user}";
        shell = pkgs.fish;
      };
    };
    homeconfig = {pkgs, ...}: {
      # this is internal compatibility configuration
      # for home-manager, don't change this!
      home.stateVersion = "24.05";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;

      imports = [
        ./shell/tmux.nix
        ./shell/fish/default.nix
        ./shell/starship
        ./user/apps/miscellaneous/spicetify.nix
      ];

      # Enable carapace completions
      programs.carapace.enable = true;

      programs.git.enable = true;

      # Used for Amperity development
      programs.java = {
        enable = true;
        package = pkgs.jdk11;
      };

      programs.bat.themes = {
        rose-pine = {
          src = pkgs.fetchFromGitHub {
            owner = "rose-pine";
            repo = "tm-theme"; # Bat uses sublime syntax for its themes
            rev = "45061dc3fda6bd2126305df8fd6c81ef5a0f9c27";
            sha256 = "sha256-N68TUiNQkyVdgEFQ4EH1PpSAjHCsavha7moXHUg89/w=";
          };
          file = "dist/themes/rose-pine.tmTheme";
        };
      };

      programs.bat.config.theme = "rose-pine";
      programs.bat.enable = true;

      programs.fzf = {
        enable = true;
        enableFishIntegration = true;
        colors = {
          "fg" = "#908caa";
          "bg" = "#191724";
          "hl" = "#ebbcba";
          "fg+" = "#e0def4";
          "bg+" = "#26233a";
          "hl+" = "#ebbcba";
          "border" = "#403d52";
          "header" = "#31748f";
          "gutter" = "#191724";
          "spinner" = "#f6c177";
          "info" = "#9ccfd8";
          "pointer" = "#c4a7e7";
          "marker" = "#eb6f92";
          "prompt" = "#908caa";
        };
      };

      home.packages = with pkgs; [
        alejandra # nix formatter
        awscli2
        clojure
        clojure-lsp
        coreutils
        difftastic
        direnv
        eza
        fd
        gnused
        htop
        httpie
        jq
        just
        k9s
        kubectx
        kubelogin # for azure
        lazydocker
        lazygit
        leiningen
        nb
        neil
        neofetch
        neovim
        nerdfonts
        nodejs
        ripgrep
        spotify
        tldr
        tree
        vault
        yazi
        zoxide
      ];

      home.sessionVariables = {
        EDITOR = "nvim";
        CARAPACE_BRIDGES = "fish,zsh,bash,inshellisense";

        # Amperity related
        VAULT_ADDR = "https://vault.amperity.top:8200";
      };

      home.sessionPath = [
        "$HOME/Development/amperity/app/bin"
      ];

      home.file."./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
      };

      # home.file."./.config/fish/" = {
      #   source = ./fish;
      #   recursive = true;
      # };

      home.file."./.config/ghostty/" = {
        source = ./ghostty;
        recursive = true;
      };

      home.file."./.config/aerospace/" = {
        source = ./aerospace;
        recursive = true;
      };

      home.file."./.config/kanata/" = {
        source = ./kanata;
        recursive = true;
      };

      home.file.".gitconfig" = {
        source = ./gitconfig;
      };

      home.file.".dircolors" = {
        source = ./dircolors;
      };
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."greed" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        (import ./modules/services/kanata.nix)
        ({config, ...}: {
          # https://github.com/zhaofengli/nix-homebrew/issues/5
          homebrew.taps = builtins.attrNames config.nix-homebrew.taps;
        })
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            inherit user;
            enable = true;
            enableRosetta = false;
            taps = {
              "conductorone/homebrew-cone" = cone-tap;
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
              "nikitabobko/homebrew-tap" = nikitabobko-tap;
            };
            mutableTaps = false;
            autoMigrate = true;
          };
        }
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.justin = homeconfig;
          home-manager.extraSpecialArgs = {
            inherit inputs;
          };
        }
      ];
      specialArgs = {
        inherit inputs;
      };
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."greed".pkgs;
  };
}
