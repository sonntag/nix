{pkgs, ...}: {
  extraPlugins = [
    (pkgs.vimUtils.buildVimPlugin {
      name = "lazyjj.nvim";
      src = pkgs.fetchFromGitHub {
        owner = "swaits";
        repo = "lazyjj.nvim";
        rev = "bba66a1351ff1f1bd078c8a1b00b8d12b3ed0017";
        hash = "sha256-h97fVlawU0oLkDuuvmUbrTFzsc92DQELvynmIRjGjjk=";
      };
    })
  ];

  extraConfigLua = ''
    require("lazyjj").setup({
      mapping = "<leader>jj"
    })
  '';
}
