{lib}: {
  keymap = key: action: desc: {
    mode = "n";
    key = key;
    action = action;
    options = {
      desc = desc;
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
