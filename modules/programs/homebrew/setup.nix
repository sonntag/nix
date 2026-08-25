{
  den.default.darwin.homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      extraFlags = [
        "--force-cleanup"
      ];
    };
  };
}
