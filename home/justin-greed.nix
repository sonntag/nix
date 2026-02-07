{pkgs, ...}: let
  pnpm-path = "$HOME/Library/pnpm";
in {
  imports = [
    ../modules/home
  ];

  home.packages = with pkgs; [
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
  sonntag.programs.nvim.enable = true;

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

  programs.codex.settings = {
    model = "gpt-5.2-codex";
    model_provider = "litellm";
    model_providers.litellm = {
      name = "LiteLLM Proxy";
      base_url = "http://localhost:4000/v1";
      wire_api = "responses";
    };
  };

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
          echo -n $password | vault login -method=okta username=sonntag password=-
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
