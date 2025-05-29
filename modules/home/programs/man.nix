{pkgs, ...}: {
  home.packages = with pkgs; [
    man
  ];

  home.sessionVariables = {
    # PAGER = "${pkgs.most}/bin/most";
    # MANPAGER = "${pkgs.most}/bin/most";
    MANROFFOPT = "-c";
    GROFF_NO_SGR = "1";
  };
}
