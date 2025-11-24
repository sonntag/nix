{
  config,
  lib,
  ...
}: let
  home = config.home.homeDirectory;
  profile = config.sonntag.ssh.profile;
in {
  config = lib.mkIf (profile == "personal") {
    sops.secrets.".ssh/id_justin" = {
      sopsFile = ./justin.yaml;
      key = "private-key";
      path = "${home}/.ssh/id_justin";
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
