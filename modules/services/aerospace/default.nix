{
  den.default.darwin.services.aerospace = {
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
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";

        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-a = "workspace A";
        alt-b = "workspace B";
        alt-c = "workspace C";
        alt-d = "workspace D";
        alt-e = "workspace E";
        alt-f = "workspace F";
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

        # See: https://nikitabobko.github.io/AeroSpace/commands#workspace-back-and-forth
        alt-tab = "workspace-back-and-forth";

        # See: https://nikitabobko.github.io/AeroSpace/commands#mode
        alt-semicolon = "mode service";
      };

      # 'service' binding mode declaration.
      # See: https://nikitabobko.github.io/AeroSpace/guide#binding-modes
      mode.service.binding = {
        esc = "mode main";

        slash = "layout tiles horizontal vertical";
        comma = "layout accordion horizontal vertical";

        minus = "resize smart -50";
        equal = "resize smart +50";

        # r = ["flatten-workspace-tree" "mode main"];
        # Toggle between floating and tiling layout
        alt-shift-f = ["layout floating tiling" "mode main"];
        # backspace = ["close-all-windows-but-current" "mode main"];

        # sticky is not yet supported https://github.com/nikitabobko/AeroSpace/issues/2
        # s = ["layout sticky tiling" "mode main"]

        h = "focus left";
        j = "focus down";
        k = "focus up";
        l = "focus right";

        alt-h = "move left";
        alt-j = "move down";
        alt-k = "move up";
        alt-l = "move right";

        alt-shift-h = ["join-with left" "mode main"];
        alt-shift-j = ["join-with down" "mode main"];
        alt-shift-k = ["join-with up" "mode main"];
        alt-shift-l = ["join-with right" "mode main"];

        "1" = "workspace 1";
        "2" = "workspace 2";
        "3" = "workspace 3";
        "4" = "workspace 4";
        a = "workspace A";
        b = "workspace B";
        c = "workspace C";
        d = "workspace D";
        e = "workspace E";
        f = "workspace F";
        g = "workspace G";
        i = "workspace I";
        m = "workspace M";
        n = "workspace N";
        o = "workspace O";
        p = "workspace P";
        q = "workspace Q";
        r = "workspace R";
        s = "workspace S";
        t = "workspace T";
        u = "workspace U";
        v = "workspace V";
        w = "workspace W";
        x = "workspace X";
        y = "workspace Y";
        z = "workspace Z";

        alt-1 = "move-node-to-workspace 1";
        alt-2 = "move-node-to-workspace 2";
        alt-3 = "move-node-to-workspace 3";
        alt-4 = "move-node-to-workspace 4";
        alt-a = "move-node-to-workspace A";
        alt-b = "move-node-to-workspace B";
        alt-c = "move-node-to-workspace C";
        alt-d = "move-node-to-workspace D";
        alt-e = "move-node-to-workspace E";
        alt-f = "move-node-to-workspace F";
        alt-g = "move-node-to-workspace G";
        alt-i = "move-node-to-workspace I";
        alt-m = "move-node-to-workspace M";
        alt-n = "move-node-to-workspace N";
        alt-o = "move-node-to-workspace O";
        alt-p = "move-node-to-workspace P";
        alt-q = "move-node-to-workspace Q";
        alt-r = "move-node-to-workspace R";
        alt-s = "move-node-to-workspace S";
        alt-t = "move-node-to-workspace T";
        alt-u = "move-node-to-workspace U";
        alt-v = "move-node-to-workspace V";
        alt-w = "move-node-to-workspace W";
        alt-x = "move-node-to-workspace X";
        alt-y = "move-node-to-workspace Y";
        alt-z = "move-node-to-workspace Z";

        tab = "workspace-back-and-forth";
        # See: https://nikitabobko.github.io/AeroSpace/commands#move-workspace-to-monitor
        alt-tab = "move-workspace-to-monitor --wrap-around next";
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
        # {
        #   "if".app-id = "company.thebrowser.Browser";
        #   run = "move-node-to-workspace B";
        # }
        {
          "if".app-id = "com.apple.iCal";
          run = "move-node-to-workspace C";
        }
        {
          "if".app-id = "com.openai.codex";
          run = "move-node-to-workspace G";
        }
        {
          "if".app-id = "com.apple.MobileSMS";
          run = "move-node-to-workspace M";
        }
        {
          "if".app-id = "com.readdle.SparkDesktop";
          run = "move-node-to-workspace M";
        }
        {
          "if".app-id = "net.whatsapp.WhatsApp";
          run = "move-node-to-workspace M";
        }
        {
          "if".app-id = "md.obsidian";
          run = "move-node-to-workspace N";
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
          "if".app-id = "com.edovia.screens.5";
          run = "move-node-to-workspace S";
        }
        {
          "if".app-id = "com.mitchellh.ghostty";
          run = "move-node-to-workspace T";
        }
        {
          "if".app-id = "com.goodsnooze.MacWhisper";
          run = "move-node-to-workspace W";
        }
        {
          "if".app-id = "us.zoom.xos";
          run = "move-node-to-workspace Z";
        }
      ];
    };
  };
}
