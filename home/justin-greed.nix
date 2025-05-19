{pkgs, ...}: {
  imports = [
    ../modules/home
  ];

  home.packages = with pkgs; [
    awscli2
    cljstyle
    devenv
    httpie
    kubectx
    kubelogin # for azure
    lazydocker
    leiningen
    nb
    neil
    nodejs
  ];

  home.sessionVariables = {
    VAULT_ADDR = "https://vault.amperity.top:8200";
  };

  home.sessionPath = [
    "$HOME/Development/amperity/app/bin"
  ];

  sonntag.programs.claude-code.enable = true;
  # sonntag.programs.nvim.enable = true;
  sonntag.programs.nixvim.enable = true;

  # Used for Amperity development
  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };

  programs.fish.shellAliases = {
    lr = "lein refresh";
    vpn = "cone get prod.vpn -d 1w";
  };

  programs.fish.functions = {
    aws-profile.body = ''
      set -gx AWS_PROFILE $argv[1]
      aws sso login
      aws configure list
    '';

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
  };

  sonntag.programs.k9s.enable = true;
}
