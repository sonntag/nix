# Creates the local checkout used by rebuild commands. The public fetch URL
# works before a new device's GitHub SSH key has been enrolled.
{
  den.default.nixible.nix-flake-checkout = {pkgs, ...}: {
    dependencies = [pkgs.git];

    playbook = [
      {
        name = "Check out the Sonntag Nix flake";
        hosts = "localhost";
        connection = "local";
        gather_facts = false;
        tasks = [
          {
            name = "Create the local data directory";
            file = {
              path = "{{ lookup('env', 'HOME') }}/.local/share";
              state = "directory";
              mode = "0755";
            };
          }
          {
            name = "Clone the flake into the local data directory";
            git = {
              repo = "https://github.com/sonntag/nix.git";
              dest = "{{ lookup('env', 'HOME') }}/.local/share/sonntag-nix";
              version = "main";
              update = false;
            };
          }
        ];
      }
    ];
  };
}
