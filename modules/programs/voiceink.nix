{
  den.aspects.voiceink.darwin = {
    homebrew.casks = ["voiceink"];

    system.defaults.CustomUserPreferences."com.prakashjoshipax.VoiceInk" = {
      IsMenuBarOnly = true;
      RecorderType = "notch";
      SUAutomaticallyUpdate = true;
      clipboardRestoreDelay = 1;
      pasteMethod = "appleScript";
      useAppleScriptPaste = true;
    };
  };
}
