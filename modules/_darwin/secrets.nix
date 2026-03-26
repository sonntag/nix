{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.secrets;
in {
  options.sonntag.secrets = {
    enable = mkEnableOption "sops-nix secrets management";
  };

  config = mkIf cfg.enable {
    sops = {
      defaultSopsFile = ./secrets/secrets.yaml;

      # Use age for decryption, disable SSH key fallback
      age.keyFile = "/Users/justin/Library/Application Support/sops/age/keys.txt";
      age.sshKeyPaths = [];
      gnupg.sshKeyPaths = [];

      secrets = {
        openai_amperity_ue2_key = {};
        openai_api_key = {};
      };
    };
  };
}
