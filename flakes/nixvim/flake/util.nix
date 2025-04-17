{lib}: {
  keymap = mode: key: action: desc: {
    mode = mode;
    key = key;
    action = action;
    options = {
      desc = desc;
    };
  };

  keymapLua = mode: key: action: desc: {
    mode = mode;
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
