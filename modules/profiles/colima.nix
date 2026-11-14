{
  den.aspects.colima.homeManager = {pkgs, ...}: {
    home.packages = with pkgs; [
      docker
    ];
    services.colima = {
      enable = true;
    };
    programs.lazydocker.enable = true;
    programs.docker-cli.enable = true;
  };
}
