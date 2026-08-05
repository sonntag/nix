{sonntag, ...}: {
  # Reusable graphical Linux profile. System integration belongs to NixOS;
  # the compositor configuration and user applications belong to Home Manager.
  sonntag.hyprland = {
    nixos = {pkgs, ...}: {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };

      security.polkit.enable = true;
      hardware.graphics.enable = true;

      services.pipewire = {
        enable = true;
        pulse.enable = true;
      };

      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
      };
    };

    homeManager = {pkgs, ...}: {
      home = {
        sessionVariables.NIXOS_OZONE_WL = "1";
        packages = with pkgs; [
          firefox
          grim
          hyprlock
          kitty
          slurp
          waybar
          wl-clipboard
          wofi
        ];
      };

      wayland.windowManager.hyprland = {
        enable = true;
        configType = "hyprlang";
        # NixOS owns the compositor and portal packages. Home Manager owns the
        # user configuration without introducing a second Hyprland version.
        package = null;
        portalPackage = null;
        xwayland.enable = true;

        settings = {
          "$mod" = "SUPER";
          monitor = [",preferred,auto,1"];

          input = {
            kb_layout = "us";
            follow_mouse = 1;
          };

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
          };

          general = {
            gaps_in = 4;
            gaps_out = 8;
            border_size = 2;
            layout = "dwindle";
          };

          decoration.rounding = 8;
          exec-once = ["${pkgs.waybar}/bin/waybar"];

          bind = [
            "$mod, Return, exec, ${pkgs.kitty}/bin/kitty"
            "$mod, D, exec, ${pkgs.wofi}/bin/wofi --show drun"
            "$mod, B, exec, ${pkgs.firefox}/bin/firefox"
            "$mod, Q, killactive"
            "$mod SHIFT, E, exit"
            "$mod, F, fullscreen"
            "$mod, V, togglefloating"
            "$mod, H, movefocus, l"
            "$mod, J, movefocus, d"
            "$mod, K, movefocus, u"
            "$mod, L, movefocus, r"
            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
          ];
        };
      };
    };
  };
}
