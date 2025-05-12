{lib}: {
  keymap = key: action: desc: {
    inherit key action;
    mode = "n";
    options = {
      inherit desc;
    };
  };

  xmap = mode: key: action: {
    inherit mode key action;
  };

  xmapd = mode: key: action: desc: {
    inherit mode key action;
    options = {
      inherit desc;
    };
  };

  nmap = key: action: {
    inherit key action;
    mode = "n";
  };

  nmapd = key: action: desc: {
    inherit key action;
    mode = "n";
    options = {
      inherit desc;
    };
  };

  keymapLua = key: action: desc: {
    mode = "n";
    key = key;
    action.__raw = "function() ${action} end";
    options = {
      desc = desc;
    };
  };

  whichkeyGroup = prefix: desc: {
    __unkeyed-1 = prefix;
    group = desc;
  };
}
