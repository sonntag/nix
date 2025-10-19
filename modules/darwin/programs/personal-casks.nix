{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.sonntag.darwin.personal-casks;
in {
  options.sonntag.darwin.personal-casks.enable =
    mkEnableOption "personal casks" // {default = true;};

  # These are the casks that should only be on my personal macs
  config.homebrew.casks = lib.mkIf cfg.enable [
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
