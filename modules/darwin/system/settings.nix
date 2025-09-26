{
  system = {
    defaults = {
      NSGlobalDomain = {
        AppleShowAllFiles = false;
        AppleShowAllExtensions = true;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticInlinePredictionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticWindowAnimationsEnabled = false;
        NSDocumentSaveNewDocumentsToCloud = false;
        AppleWindowTabbingMode = "manual";
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        NSScrollAnimationEnabled = false;
        NSStatusItemSpacing = 12;
        NSStatusItemSelectionPadding = 6;
        NSWindowResizeTime = 0.01;
        NSWindowShouldDragOnGesture = true;
        "com.apple.trackpad.enableSecondaryClick" = true;
        "com.apple.swipescrolldirection" = true;
        _HIHideMenuBar = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 3;
      };
      dock = {
        autohide = true;
        autohide-delay = 0.1;
        autohide-time-modifier = 0.1;
        expose-animation-duration = 0.25;
        expose-group-apps = true;
        launchanim = false;
        mineffect = "scale";
        minimize-to-application = true;
        mouse-over-hilite-stack = true;
        mru-spaces = false;
        orientation = "bottom";
        show-process-indicators = true;
        show-recents = true;
        showhidden = true;
        slow-motion-allowed = false;
        static-only = false;
        tilesize = 42;
        wvous-tl-corner = 1;
        wvous-bl-corner = 1;
        wvous-tr-corner = 1;
        wvous-br-corner = 1;
      };
      finder = {
        CreateDesktop = false;
        FXPreferredViewStyle = "Nlsv";
        FXDefaultSearchScope = "SCcf";
        FXEnableExtensionChangeWarning = false;
        NewWindowTarget = "Home";
        ShowPathbar = true;
        ShowStatusBar = true;
      };
      spaces = {
        spans-displays = true;
      };
      trackpad = {
        Clicking = false;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = false;
        TrackpadThreeFingerTapGesture = 0;
      };
      CustomUserPreferences = {
        "com.apple.AdLib".allowApplePersonalizedAdvertising = false;
      };
    };

    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };
    # activationScripts.postUserActivation.text = ''
    #   # Following line should allow us to avoid a logout/login cycle
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';
  };
}
