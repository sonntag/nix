{pkgs, ...}: {
  imports = [
    ../modules/home
  ];

  home.packages = with pkgs; [
    awscli2
    cljstyle
    clojure
    clojure-lsp
    direnv
    httpie
    k9s
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
  sonntag.programs.nvim.enable = true;
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
  };
}
