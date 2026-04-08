{pkgs, ...}: let
  pnpm-path = "$HOME/Library/pnpm";

  app-worktree = pkgs.writeShellScriptBin "app-worktree" ''
    set -euo pipefail

    usage() {
      echo "Usage: app-worktree <name> [base-branch]" >&2
      echo "Creates a git worktree and tmux session for the app repo." >&2
      exit 1
    }

    if [ $# -lt 1 ]; then
      usage
    fi

    NAME="$1"
    BASE_BRANCH="''${2:-origin/main}"
    REPO_DIR="$HOME/Development/amperity/app"
    WORKTREE_DIR="$HOME/Development/amperity/app-worktrees/$NAME"
    BRANCH_NAME="sonntag/$NAME"
    SESSION_NAME="app/$NAME"

    git -C "$REPO_DIR" fetch origin

    if ! git -C "$REPO_DIR" worktree add -b "$BRANCH_NAME" "$WORKTREE_DIR" "$BASE_BRANCH"; then
      echo "Failed to create worktree" >&2
      exit 1
    fi

    tmux new-session -d -s "$SESSION_NAME" -c "$WORKTREE_DIR"
    echo "Created worktree at $WORKTREE_DIR"
    echo "Created tmux session: $SESSION_NAME"
    echo "Attach with: tmux attach -t $SESSION_NAME"
  '';
in {
  home.packages = with pkgs; [
    app-worktree
    httpie
    lazydocker
    # TODO: pulling from nixpkgs uses the wrong java version.
    # Need to figure out how to overwrite this
    # leiningen
    nb
    neil
    nodejs
    pnpm
  ];

  sonntag.wallpaper.image.path = ../../../backgrounds/rancho-cucamonga-tree.png;

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.amperity.top:8200";
    JAVA_HOME = "$(/usr/libexec/java_home -v 17)";
    PNPM_HOME = "${pnpm-path}";
  };

  home.sessionPath = [
    "$HOME/Development/amperity/app/bin"
    "${pnpm-path}"
  ];

  sonntag.ssh.profile = "work";

  sonntag.mcp.atlassian.enable = true;
  sonntag.mcp.playwright.enable = true;
  sonntag.mcp.slack.enable = true;

  # sonntag.services.ollama.enable = true;

  # Used for Amperity development
  # TODO: re-enable this
  # programs.java = {
  #   enable = true;
  #   package = pkgs.jdk17;
  # };

  programs.awscli = {
    enable = true;
  };

  programs.fish.shellAliases = {
    lr = "lein refresh";
    vpn = "cone get prod.vpn -d 1w";
    # pnpm = "${pnpm-path}/aikido-pnpm";
  };

  # This is super hacky, but needed for getting AikidoSec/safe-chain setup
  # TODO: figure out how to configure safe-chain as a nix module
  programs.fish.shellInit = ''
    source ~/.safe-chain/scripts/init-fish.fish
  '';

  programs.fish.functions = {
    aws-profile.body = ''
      set -gx AWS_PROFILE $argv[1]
      ${pkgs.awscli2}/bin/aws sso login
      ${pkgs.awscli2}/bin/aws configure list
    '';

    # TODO: this should move to amperity flake
    # TODO: can I reference the script without having to install it?
    # TODO: is there a better way to do this? such as translating the script into a function and adding it to may environment?
    # aws-profile.body = ''
    #   fenv source /run/current-system/sw/bin/aws-profile-script $argv[1]
    # '';

    switch-vault.body = ''
      if test (count $argv) -ne 1
        echo "Usage: switch-vault <stack-name>" >&2
        echo "Updates VAULT_ADDR in this shell to the Vault address of the given stack." >&2
        return 1
      end

      set stack $argv[1]

      switch $stack
          case aws-mantle
              set -gx VAULT_ADDR "https://vault.amperity.top:8200"
          case aws-dev
              set -gx VAULT_ADDR "https://vault.dev.amperity.systems:8200"
          case aws-stage
              set -gx VAULT_ADDR "https://vault.stage.amperity.systems:8200"
          case aws-prod
              set -gx VAULT_ADDR "https://vault.prod.amperity.systems:8200"
          case aws-prod-cc1
              set -gx VAULT_ADDR "https://vault.aws-prod-cc1.amperity.systems:8200"
          case az-stage
              set -gx VAULT_ADDR "https://vault.az-stage.amperity.systems:8200"
          case az-prod
              set -gx VAULT_ADDR "https://vault.az-prod.amperity.systems:8200"
          case az-prod-en1
              set -gx VAULT_ADDR "https://vault.az-prod-en1.amperity.systems:8200"
          case '*'
              echo "Unknown stack: $stack" >&2
              return 1
      end
    '';

    vault-login.body = ''
      read -s -P "Enter Okta password \(hidden\): " password
      echo

      set current_addr $VAULT_ADDR

      for stack in aws-mantle aws-dev aws-stage aws-prod aws-prod-cc1 az-stage az-prod az-prod-en1
          switch-vault $stack
          echo "Logging into $stack"
          echo -n $password | vault login -method=oidc
          if test $status -ne 0
              echo "Failed to login to $stack"
              continue
          end
          echo "Logged into $stack"
      end

      set -e password
      set -gx VAULT_ADDR $current_addr
    '';

    codex-setup.body = ''
      set original_addr $VAULT_ADDR
      switch-vault az-stage
      set -gx OPENAI_AMPERITY_UE2_KEY (vault read -field=key secret/service/openai/amperity-ue2)
      if test $status -eq 0
          echo "OPENAI_AMPERITY_UE2_KEY loaded from vault"
      else
          echo "Failed to load API key from vault" >&2
          echo "Make sure you're logged in (run vault-login)" >&2
      end
      set -gx VAULT_ADDR $original_addr
    '';
  };

  sonntag.programs.k9s.enable = true;
}
