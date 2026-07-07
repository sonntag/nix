{
  den.aspects.justin.homeManager = {
    inputs,
    pkgs,
    ...
  }: {
    programs.helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings = {
        theme = "rose_pine";

        editor = {
          auto-save = {
            focus-lost = true;
            after-delay.enable = true;
          };

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
        };

        keys = {
          normal = {
            space = {
              q = ":q";
              space = "file_picker";
              w = ":w";
            };
          };
        };
      };
    };
  };
}
