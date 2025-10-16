{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    awscli2
    # azure-cli
    babashka
    cljstyle
    clojure
    clojure-lsp
    jet
    # kubectx
    # kubelogin
    nodejs
  ];

  imports = [
    ./homebrew.nix
  ];
}
