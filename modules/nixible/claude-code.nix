# Installs Claude Code via its native installer for every target whose resolved
# Nixible policy leaves this playbook enabled.
{
  den.default.nixible.claude-code = {pkgs, ...}: {
    # `curl`/`bash` exist on the OS, but pin them so the run is reproducible
    # regardless of the caller's PATH.
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
            # verification, etc.) that aren't on the Nix wrapper's PATH.
            environment.PATH = "{{ lookup('env', 'PATH') }}:/usr/bin:/bin:/usr/sbin:/sbin";
            # `creates` makes this idempotent: skipped once installed.
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
}
