{
  lib,
  pkgs,
  ...
}: {
  programs.jjui.enable = true;
  programs.jujutsu = with lib; {
    enable = true;
    settings = {
      user = {
        name = "Justin Sonntag";
        email = mkDefault "justin.sonntag@gmail.com";
      };
      ui = {
        diff-formatter = ["${pkgs.difftastic}/bin/difft" "--color=always" "$left" "$right"];
        default-command = "status";
      };
    };
  };

  home.shellAliases = {
    je = "${pkgs.jujutsu}/bin/jj edit";
    jl = "${pkgs.jujutsu}/bin/jj log";
    jn = "${pkgs.jujutsu}/bin/jj new --no-edit";
    jne = "${pkgs.jujutsu}/bin/jj new";
    jbc = "${pkgs.jujutsu}/bin/jj bookmark create";

    # fetch and push
    jf = "${pkgs.jujutsu}/bin/jj git fetch";
    jp = "${pkgs.jujutsu}/bin/jj git push -Nr \"fork_point(trunk()..@)-::@ | @::\"";

    # rebase
    jr = "${pkgs.jujutsu}/bin/jj rebase";

    # diffs
    jd = "jdn | ${pkgs.fzf}/bin/fzf --preview \"${pkgs.jujutsu}/bin/jj diff {}\" --height=100% --preview-window=up:80%";
    jdn = "${pkgs.jujutsu}/bin/jj diff --name-only";

    # diffs from main
    jdm = "jdmn | ${pkgs.fzf}/bin/fzf --preview \"${pkgs.jujutsu}/bin/jj diff -f \\\"fork_point(trunk()..@)-\\\" {}\" --height=100% --preview-window=up:80%";
    jdmn = "${pkgs.jujutsu}/bin/jj diff -f \"fork_point(trunk()..@)-\" --name-only --no-pager";
  };
}
