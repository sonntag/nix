{
  config,
  pkgs,
  ...
}: let
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
  sonntag.programs.claude-code.enable = true;
  sonntag.programs.nvim.enable = true;
  # sonntag.programs.nixvim.enable = true;

  sonntag.services.ollama.enable = true;

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

  darwin.dock = {
    enable = true;
    entries = [
      {path = "/System/Applications/Messages.app";}
      {path = "/Applications/Arc.app";}
      {path = "/Applications/Spark Desktop.app";}
      {path = "/Applications/Things3.app";}
      {path = "/Applications/Obsidian.app";}
      {path = "/Applications/Slack.app";}
      {path = "/System/Applications/Calendar.app";}
      {path = "/Applications/Ghostty.app";}
      {path = "/Applications/zoom.us.app";}
      {path = "/Applications/Sublime Text.app";}
      {
        path = "${config.home.homeDirectory}/Desktop";
        section = "others";
        options = "--sort dateadded --view fan --display stack";
      }
      {
        path = "${config.home.homeDirectory}/Downloads";
        section = "others";
        options = "--sort dateadded --view fan --display stack";
      }
    ];
  };
}
