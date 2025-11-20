{
  services.aerospace = {
    enable = true;
    settings = {
      # Normalizations. See: https://nikitabobko.github.io/AeroSpace/guide#normalization
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;

      # See: https://nikitabobko.github.io/AeroSpace/guide#layouts
      accordion-padding = 30;

      # Possible values: tiles|accordion
      default-root-container-layout = "accordion";

      # Possible values: horizontal|vertical|auto
      # 'auto' means: wide monitor (anything wider than high) gets horizontal orientation,
      #               tall monitor (anything higher than wide) gets vertical orientation
      default-root-container-orientation = "auto";

      # Possible values: (qwerty|dvorak)
      # See https://nikitabobko.github.io/AeroSpace/guide#key-mapping
      key-mapping.preset = "dvorak";

      # Gaps between windows (inner-*) and between monitor edges (outer-*).
      # Possible values:
      # - Constant:     gaps.outer.top = 8
      # - Per monitor:  gaps.outer.top = [{ monitor.main = 16 }, { monitor."some-pattern" = 32 }, 24]
      #                 In this example, 24 is a default value when there is no match.
      #                 Monitor pattern is the same as for 'workspace-to-monitor-force-assignment'.
      #                 See: https://nikitabobko.github.io/AeroSpace/guide#assign-workspaces-to-monitors
      gaps = {
        inner = {
          horizontal = 5;
          vertical = 5;
        };
        outer = {
          left = [{monitor.dell = 128;} 5];
          bottom = 5;
          top = 5;
          right = [{monitor.dell = 128;} 5];
        };
      };

      # 'main' binding mode declaration
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      # 'main' binding mode must be always presented
      # Fallback value (if you omit the key): mode.main.binding = {}
      mode.main.binding = {
        alt-slash = "layout tiles horizontal vertical";
        alt-comma = "layout accordion horizontal vertical";

        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";

        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-a = "workspace A";
        alt-b = "workspace B";
        alt-c = "workspace C";
        alt-d = "workspace D";
        alt-e = "workspace E";
        alt-g = "workspace G";
        alt-i = "workspace I";
        alt-m = "workspace M";
        alt-n = "workspace N";
        alt-o = "workspace O";
        alt-p = "workspace P";
        alt-q = "workspace Q";
        alt-r = "workspace R";
        alt-s = "workspace S";
        alt-t = "workspace T";
        alt-u = "workspace U";
        alt-v = "workspace V";
        alt-w = "workspace W";
        alt-x = "workspace X";
        alt-y = "workspace Y";
        alt-z = "workspace Z";

        alt-shift-1 = ["move-node-to-workspace 1" "workspace 1"];
        alt-shift-2 = ["move-node-to-workspace 2" "workspace 2"];
        alt-shift-3 = ["move-node-to-workspace 3" "workspace 3"];
        alt-shift-4 = ["move-node-to-workspace 4" "workspace 4"];
        alt-shift-a = ["move-node-to-workspace A" "workspace A"];
        alt-shift-b = ["move-node-to-workspace B" "workspace B"];
        alt-shift-c = ["move-node-to-workspace C" "workspace C"];
        alt-shift-d = ["move-node-to-workspace D" "workspace D"];
        alt-shift-e = ["move-node-to-workspace E" "workspace E"];
        alt-shift-g = ["move-node-to-workspace G" "workspace G"];
        alt-shift-i = ["move-node-to-workspace I" "workspace I"];
        alt-shift-m = ["move-node-to-workspace M" "workspace M"];
        alt-shift-n = ["move-node-to-workspace N" "workspace N"];
        alt-shift-o = ["move-node-to-workspace O" "workspace O"];
        alt-shift-p = ["move-node-to-workspace P" "workspace P"];
        alt-shift-q = ["move-node-to-workspace Q" "workspace Q"];
        alt-shift-r = ["move-node-to-workspace R" "workspace R"];
        alt-shift-s = ["move-node-to-workspace S" "workspace S"];
        alt-shift-t = ["move-node-to-workspace T" "workspace T"];
        alt-shift-u = ["move-node-to-workspace U" "workspace U"];
        alt-shift-v = ["move-node-to-workspace V" "workspace V"];
        alt-shift-w = ["move-node-to-workspace W" "workspace W"];
        alt-shift-x = ["move-node-to-workspace X" "workspace X"];
        alt-shift-y = ["move-node-to-workspace Y" "workspace Y"];
        alt-shift-z = ["move-node-to-workspace Z" "workspace Z"];

        alt-shift-f = "fullscreen";

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        alt-tab = "workspace-back-and-forth";
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        alt-shift-tab = "move-workspace-to-monitor --wrap-around next";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        alt-shift-semicolon = "mode service";
      };

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      mode.service.binding = {
        esc = "mode main";

        r = ["flatten-workspace-tree" "mode main"];
        # Toggle between floating and tiling layout
        f = ["layout floating tiling" "mode main"];
        backspace = ["close-all-windows-but-current" "mode main"];

        # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        # s = ["layout sticky tiling" "mode main"]

        alt-shift-h = ["join-with left" "mode main"];
        alt-shift-j = ["join-with down" "mode main"];
        alt-shift-k = ["join-with up" "mode main"];
        alt-shift-l = ["join-with right" "mode main"];
      };

      workspace-to-monitor-force-assignment = {
        "C" = "built-in";
        "G" = "built-in";
        "M" = "built-in";
        "R" = "built-in";
        "S" = "built-in";
        "Y" = "built-in";
      };

      # Find these app-ids using `aerospace list-apps`
      on-window-detected = [
        {
          "if".app-id = "com.sublimetext.4";
          run = "move-node-to-workspace 2";
        }
        {
          "if".app-id = "com.ableton.live";
          run = "move-node-to-workspace A";
        }
        {
          "if".app-id = "company.thebrowser.Browser";
          run = "move-node-to-workspace B";
        }
        {
          "if".app-id = "com.apple.iCal";
          run = "move-node-to-workspace C";
        }
        {
          "if".app-id = "com.openai.chat";
          run = "move-node-to-workspace G";
        }
        {
          "if".app-id = "com.apple.MobileSMS";
          run = "move-node-to-workspace M";
        }
        {
          "if".app-id = "com.1password.1password";
          run = "move-node-to-workspace P";
        }
        {
          "if".app-id = "com.spotify.client";
          run = "move-node-to-workspace P";
        }
        {
          "if".app-id = "com.culturedcode.ThingsMac";
          run = "move-node-to-workspace R";
        }
        {
          "if".app-id = "com.tinyspeck.slackmacgap";
          run = "move-node-to-workspace S";
        }
        {
          "if".app-id = "com.mitchellh.ghostty";
          run = "move-node-to-workspace T";
        }
        {
          "if".app-id = "us.zoom.xos";
          run = "move-node-to-workspace Z";
        }
      ];
    };
  };
}
