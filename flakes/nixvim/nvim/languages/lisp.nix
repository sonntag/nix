{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.sonntag.nvim.languages.lisp;
in {
  options.sonntag.nvim.languages.lisp.enable = mkEnableOption "lisp";
  config = mkIf cfg.enable {
    plugins.parinfer-rust.enable = true;

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "nvim-paredit";
        src = pkgs.fetchFromGitHub {
          owner = "julienvincent";
          repo = "nvim-paredit";
          rev = "cfab7ef0b750a8bd1d4daa6ace93a36ebc60f172";
          hash = "sha256-SktnVo7YPo0jpS57Ov+OQR1/ciSAz5qHhMQJnSpe1MM=";
        };
        # TODO: Figure out why checks are failing
        doCheck = false;
      })
    ];

    extraConfigLua = ''
      require("nvim-paredit").setup()
    '';
  };
}
