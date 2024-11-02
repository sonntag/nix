{
  description = "Example Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nix-darwin,
    home-manager,
  }: let
    configuration = {pkgs, ...}: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [
        pkgs.mas
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";

        taps = [
          "conductorone/cone"
          "nikitabobko/tap" # contains aerospace
        ];
        brews = [
          "azure-cli"
          "kanata"
          "conductorone/cone/cone"
        ];
        casks = [
          "1password-cli"
          "aerospace"
          "anki"
          "ankiapp"
          "cljstyle"
          "docker"
          "obsidian"
          "openscad"
          "raycast"
          "sublime-text"
        ];
        masApps = {
          "1Password for Safari" = 1569813296;
          "Day One" = 1055511498;
          FitFileExplorer = 1244431640;
          NordVPN = 905953485;
          Notenik = 1465997984;
          PCalc = 403504866;
          Slack = 803453959;
          Spark = 1176895641;
          Things = 904280696;
          Yoink = 457622435;
        };
      };

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Allow touch-id for sudo
      security.pam.enableSudoTouchIdAuth = true;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      #programs.zsh.enable = true;  # default shell on catalina
      programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      nixpkgs.config.allowUnfree = true;

      environment.shells = [pkgs.fish];
      environment.loginShell = pkgs.fish;

      users.users.justin = {
        name = "justin";
        home = "/Users/justin";
        shell = pkgs.fish;
      };
    };
    homeconfig = {pkgs, ...}: {
      # this is internal compatibility configuration
      # for home-manager, don't change this!
      home.stateVersion = "24.05";
      # Let home-manager install and manage itself.
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
        alejandra # nix formatter
        awscli2
        bat
        clojure
        clojure-lsp
        coreutils
        difftastic
        eza
        fd
        fzf
        git
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
        openscad
        ripgrep
        starship
        thefuck
        tldr
        tmux
        tree
        vault
        yazi
        zoxide
      ];

      home.sessionVariables = {
        EDITOR = "vim";
      };

      home.file."./.config/nvim/" = {
        source = ./nvim;
        recursive = true;
      };

      home.file."./.config/fish/" = {
        source = ./fish;
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

      home.file."./.config/starship.toml" = {
        source = ./starship.toml;
      };

      home.file."./.config/tmux/" = {
        source = ./tmux;
        recursive = true;
      };
    };
  in {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."greed" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.verbose = true;
          home-manager.users.justin = homeconfig;
        }
      ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."greed".pkgs;
  };
}
