{sonntag, ...}: {
  # Huginn adds unattended login and an SSH-tunneled WayVNC session to the
  # reusable Hyprland profile. Hypervisor hardware and networking remain the
  # responsibility of the consuming infrastructure flake.
  sonntag.huginn = {
    includes = [sonntag.hyprland];

    nixos = {pkgs, ...}: {
      users.users.justin = {
        isNormalUser = true;
        description = "Justin Sonntag";
        extraGroups = ["networkmanager" "render" "video" "wheel"];
        shell = pkgs.fish;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFlBtjW+gOK9FSpo9XJS+0Y8Wg+4GDGOOcizYGJ1CNdS justin@wrath"
        ];
      };

      programs.fish.enable = true;
      security.sudo.wheelNeedsPassword = false;

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.hyprland}/bin/Hyprland";
          user = "justin";
        };
      };
    };

    homeManager = {
      lib,
      pkgs,
      ...
    }: {
      home = {
        stateVersion = "24.05";
        sessionVariables.WLR_RENDERER_ALLOW_SOFTWARE = "1";
        packages = [pkgs.wayvnc];
      };

      wayland.windowManager.hyprland.settings = {
        monitor = lib.mkForce [",1920x1080@60,auto,1"];
        cursor.no_hardware_cursors = true;

        # WayVNC must inherit the compositor instance environment. It binds
        # only to loopback and is reached through an SSH tunnel.
        exec-once = lib.mkAfter [
          "${pkgs.wayvnc}/bin/wayvnc 127.0.0.1 5900"
        ];
      };
    };
  };
}
