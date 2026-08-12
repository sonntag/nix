# Installs the Pi coding agent via its native installer. Pi's launcher needs
# Node at runtime, so Home Manager still owns that declarative dependency; only
# the imperative native installation lives in Nixible.
{
  den.aspects.justin.homeManager = {pkgs, ...}: {
    home.packages = [pkgs.nodejs_22];
  };

  den.default.nixible.pi-coding-agent = {pkgs, ...}: {
    dependencies = [pkgs.curl pkgs.bash pkgs.nodejs_22];

    playbook = [
      {
        name = "Install Pi coding agent";
        hosts = "localhost";
        connection = "local";
        gather_facts = false;
        tasks = [
          {
            name = "Run the pi.dev native installer";
            environment.PATH = "{{ lookup('env', 'PATH') }}:/usr/bin:/bin:/usr/sbin:/sbin";
            shell = {
              cmd = "curl -fsSL https://pi.dev/install.sh | sh";
              creates = "{{ lookup('env', 'HOME') }}/.local/bin/pi";
              executable = "${pkgs.bash}/bin/bash";
            };
          }
        ];
      }
    ];
  };
}
