{
  den.aspects.amperity.homeManager = {config, ...}: {
    sops.secrets.".ssh/id_amperity" = {
      sopsFile = ./amperity.yaml;
      key = "private-key";
      path = "${config.home.homeDirectory}/.ssh/id_amperity";
    };

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          addKeysToAgent = "yes";
          identityFile = "~/.ssh/id_amperity";
          extraOptions = {
            # This should only be for darwin
            "UseKeychain" = "yes";
          };
        };
      };
    };

    home.file = {
      "./.ssh/id_amperity.pub".source = ./amperity.pub;
    };
  };
}
