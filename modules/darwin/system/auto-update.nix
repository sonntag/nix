{inputs, ...}: {
  imports = [inputs.amperity.darwinModules];
  services.comin = {
    enable = true;
    remotes = [
      {
        name = "origin";
        url = "github:sonntag/nix";
        branches.main.name = "main";
      }
    ];
  };
}
