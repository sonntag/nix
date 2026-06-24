# Installs Claude Code via its native installer on activation. Attached to the
# `justin` aspect so it applies wherever justin is configured. Move this block
# to a narrower aspect to scope it.
{
  den.aspects.justin.homeManager = {pkgs, ...}: {
    nixible.playbooks.claude-code = {
      # `curl`/`bash` exist on the OS, but pin them so the run is reproducible
      # regardless of what's on PATH at activation time.
      dependencies = [pkgs.curl pkgs.bash];

      playbook = [
        {
          name = "Install Claude Code";
          hosts = "localhost";
          connection = "local";
          gather_facts = false;
          tasks = [
            {
              name = "Run the claude.ai native installer";
              # The installer shells out to system tools (`shasum` for checksum
              # verification, etc.) that aren't on PATH during home-manager
              # activation. Append the standard system bin dirs so it can find
              # them, keeping the pinned curl/bash the nixible wrapper puts first.
              environment.PATH = "{{ lookup('env', 'PATH') }}:/usr/bin:/bin:/usr/sbin:/sbin";
              # `creates` makes this idempotent: skipped once the binary the
              # installer drops in ~/.local/bin exists, so it only actually hits
              # the network on first install.
              shell = {
                cmd = "curl -fsSL https://claude.ai/install.sh | bash";
                creates = "{{ lookup('env', 'HOME') }}/.local/bin/claude";
                executable = "${pkgs.bash}/bin/bash";
              };
            }
          ];
        }
      ];
    };
  };
}
