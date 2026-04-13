{
  den.aspects.personal.homeManager = {config, ...}: {
    sops.secrets.".ssh/id_justin" = {
      sopsFile = ./justin.yaml;
      key = "private-key";
      path = "${config.home.homeDirectory}/.ssh/id_justin";
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          addKeysToAgent = "yes";
          identityFile = "~/.ssh/id_justin";
          extraOptions = {
            # This should only be for darwin
            "UseKeychain" = "yes";
          };
        };
      };
    };

    home.file = {
      "./.ssh/id_justin.pub".source = ./justin.pub;
    };
  };
}
