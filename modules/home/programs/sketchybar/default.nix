{
  lib,
  pkgs,
  ...
}: {
  xdg.configFile = {
    sketchybar = {
      source = lib.cleanSourceWith {src = lib.cleanSource ./config/.;};
      recursive = true;
    };

    "sketchybar/sketchybarrc" = {
      executable = true;
      text = ''
        #!/usr/bin/env lua

        -- Add the sketchybar module to the package cpath (the module could be
        -- installed into the default search path then this would not be needed)
        package.cpath = package.cpath .. ";${pkgs.sbarlua}/lib/lua/${pkgs.lua.luaversion}/sketchybar.so"

        Sbar = require("sketchybar")
        Sbar.exec("killall sketchyhelper || sketchyhelper git.felix.sketchyhelper >/dev/null 2>&1 &")
        Sbar.begin_config()
        require("init")
        Sbar.hotload(true)
        Sbar.end_config()
        Sbar.event_loop()
      '';
    };
  };
}
