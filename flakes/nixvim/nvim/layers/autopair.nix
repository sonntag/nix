{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.sonntag.layers.autopair;
in {
  options.sonntag.layers.autopair.enable = mkEnableOption "autopair" // {default = true;};
  config = mkIf cfg.enable {
    # plugins.nvim-autopairs = {
    #   enable = true;
    #   settings = {
    #     map_bs = false;
    #   };
    # };

    extraPlugins = [
      (pkgs.vimUtils.buildVimPlugin {
        name = "ultimate-autopair";
        src = pkgs.fetchFromGitHub {
          owner = "altermo";
          repo = "ultimate-autopair.nvim";
          rev = "b24b97c538b71b6de0ce9d84e47df27b6ecafd76";
          hash = "sha256-yPPb7G7/Xx0ybhhRcXCZzGRrehgWqgWRE3nazPPvcjc=";
        };
      })
    ];

    extraConfigLua = ''
      require("ultimate-autopair").setup()
    '';
  };
}
