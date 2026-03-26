{
  config,
  lib,
  ...
}: let
  home = config.home.homeDirectory;
  profile = config.sonntag.ssh.profile;
in {
  config = lib.mkIf (profile == "work") {
    sops.secrets.".ssh/id_amperity" = {
      sopsFile = ./amperity.yaml;
      key = "private-key";
      path = "${home}/.ssh/id_amperity";
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
