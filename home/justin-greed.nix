{pkgs, ...}: {
  home.stateVersion = "24.05";

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

  programs.claude-code.enable = true;

  fonts.fontconfig.enable = true;

  # Used for Amperity development
  programs.java = {
    enable = true;
    package = pkgs.jdk11;
  };
}
