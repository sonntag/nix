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
        pkgs.neofetch
        pkgs.vim
      ];

      homebrew = {
        enable = true;
        onActivation.cleanup = "zap";

        taps = [
          "azure/kubelogin"
          "babashka/brew"
          "borkdude/brew"
          "conductorone/cone"
          "derailed/k9s"
          "homebrew/bundle"
          "homebrew/cask-fonts"
          "homebrew/services"
          "koekeishiya/formulae"
          "nikitabobko/tap"
          "oven-sh/bun"
        ];
        brews = [
          "asdf"
          "awscli"
          "azure-cli"
          "bash"
          "bat"
          "clojure"
          "clojure-lsp"
          "difftastic"
          "elm"
          "eza"
          "fd"
          "fzf"
          "libavif"
          "gh"
          "git"
          "gleam"
          "gnu-sed"
          "gnutls"
          "gnupg"
          "gnuplot"
          "go"
          "helm"
          "htop"
          "httpie"
          "hugo"
          "jq"
          "just"
          "kanata"
          "kubectx"
          "lazydocker"
          "lazygit"
          "leiningen"
          "mas"
          "mkcert"
          "ripgrep"
          "nb"
          "neovim"
          "node"
          "poetry"
          "rustup"
          "starship"
          "stow"
          "tailwindcss"
          "tfenv"
          "thefuck"
          "tldr"
          "tmux"
          "tree"
          "vault"
          "virtualenv"
          "yarn"
          "yazi"
          "zoxide"
          "azure/kubelogin/kubelogin"
          "babashka/brew/neil"
          "conductorone/cone/cone"
          "derailed/k9s/k9s"
          "oven-sh/bun/bun"
        ];
        casks = [
          "1password-cli"
          "aerospace"
          "anki"
          "ankiapp"
          "autodesk-fusion"
          "bartender"
          "bettertouchtool"
          "chromedriver"
          "cljstyle"
          "db-browser-for-sqlite"
          "devtoys"
          "docker"
          "flutter"
          "font-sauce-code-pro-nerd-font"
          "font-symbols-only-nerd-font"
          "font-victor-mono-nerd-font"
          "kitty"
          "logitune"
          "microsoft-azure-storage-explorer"
          "obsidian"
          "openscad"
          "racket"
          "raycast"
          "sublime-text"
          "warp"
          "wezterm"
        ];
        masApps = {
          "1Password for Safari" = 1569813296;
          "Day One" = 1055511498;
          "FitFileExplorer" = 1244431640;
          "GarageBand" = 682658836;
          "Gifox" = 1461845568;
          "iMovie" = 408981434;
          "Keynote" = 409183694;
          "NordVPN" = 905953485;
          "Notenik" = 1465997984;
          "Numbers" = 409203825;
          "Pages" = 409201541;
          "PCalc" = 403504866;
          "Slack" = 803453959;
          "Spark" = 1176895641;
          "TestFlight" = 899247664;
          "Things" = 904280696;
          "Ulysses" = 1225570693;
          "Xcode" = 497799835;
          "Yoink" = 457622435;
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
      ];

      home.sessionVariables = {
        EDITOR = "vim";
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
