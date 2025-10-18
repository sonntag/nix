{
  config,
  lib,
  ...
}: {
  options = {
    sonntag.darwin.personal-casks.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };

  # These are the casks that should only be on my personal macs
  config.homebrew.casks = lib.mkIf config.sonntag.darwin.personal-casks.enable [
    "ableton-live-suite"
    "bambu-studio"
    "blackhole-2ch"
    "chatgpt"
    "dropbox"
    "nordvpn"
    "rekordbox"
    "tor-browser"
    "whatsapp"
  ];
}
