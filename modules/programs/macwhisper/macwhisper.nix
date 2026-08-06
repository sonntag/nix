{
  den.aspects.macwhisper = {
    darwin.homebrew.casks = ["macwhisper"];

    homeManager = {
      config,
      lib,
      ...
    }: let
      plist = lib.generators.toPlist {escape = true;} {
        licenseKey = "@LICENSE_KEY@";
        allowsCloudTranscription = false;
        allowsAddingAIServices = true;
        allowsRemoteTranslation = false;
      };
    in {
      sops.secrets."macwhisper/license" = {
        sopsFile = ./secrets.yaml;
        key = "license-key";
      };

      sops.templates."mdmlicense.plist" = {
        path = "${config.home.homeDirectory}/Library/Application Support/MacWhisper/mdmlicense.plist";
        content =
          builtins.replaceStrings
          ["@LICENSE_KEY@"] [config.sops.placeholder."macwhisper/license"]
          plist;
        mode = "0400";
      };
    };
  };
}
