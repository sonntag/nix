# Keeps a local checkout of this flake at the stable path used by the rebuild
# commands. On a new machine, the first activation can run from the GitHub
# flake URL; this play then creates the checkout used by subsequent rebuilds.
{
  den.aspects.justin.homeManager = {
    config,
    pkgs,
    ...
  }: {
    nixible.playbooks.nix-flake-checkout = {
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
                path = "${config.home.homeDirectory}/.local/share";
                state = "directory";
                mode = "0755";
              };
            }
            {
              name = "Clone the flake into the local data directory";
              git = {
                repo = "https://github.com/sonntag/nix.git";
                dest = "${config.home.homeDirectory}/.local/share/sonntag-nix";
                version = "main";
                # Do not pull during activation: changing the source tree after
                # evaluation makes the active generation and checkout disagree.
                # Flake updates should remain an explicit Git operation.
                update = false;
              };
            }
          ];
        }
      ];
    };
  };
}
