# Installs the Pi coding agent on activation. Attached to the `foo` aspect so it
# applies wherever foo is configured. Move this block to a different aspect
# (e.g. `justin`/`amperity`/`work`/a host) to scope it.
#
# We intentionally do NOT use the `curl https://pi.dev/install.sh | sh` wrapper:
# it decides interactive-vs-batch by whether `/dev/tty` is openable, not by
# whether stdin/stdout is a terminal. A terminal-driven activation
# (`darwin-rebuild switch`) leaves a reachable controlling tty, so the wrapper
# enters its interactive menu and stalls on `stty`/`dd` against /dev/tty. There
# is no env/flag override, and forcing the batch branch needs `setsid` (absent
# on macOS). So we run the exact npm command the wrapper would have run.
{
  den.aspects.foo.homeManager = {pkgs, ...}: {
    nixible.playbooks.pi-coding-agent = {
      # Pi is an npm package (requires Node >= 22.19). Pin node/npm so the run is
      # reproducible regardless of what's on PATH at activation time.
      dependencies = [pkgs.bash pkgs.nodejs_22];

      playbook = [
        {
          name = "Install Pi coding agent";
          hosts = "localhost";
          connection = "local";
          gather_facts = false;
          tasks = [
            {
              name = "Install @earendil-works/pi-coding-agent via npm";
              # node/npm come from the pinned dependency (captured via the env
              # PATH lookup); append the standard system bin dirs for anything
              # npm shells out to.
              environment.PATH = "{{ lookup('env', 'PATH') }}:/usr/bin:/bin:/usr/sbin:/sbin";
              # `--prefix ~/.local` matches where pi.dev's installer puts it when
              # the npm global prefix isn't writable (it is read-only under Nix),
              # so the binary lands in ~/.local/bin/pi. `creates` makes this
              # idempotent: skipped once that binary exists.
              shell = {
                cmd = "npm install -g --ignore-scripts --min-release-age=0 --no-fund --no-audit --prefix {{ lookup('env', 'HOME') }}/.local @earendil-works/pi-coding-agent";
                creates = "{{ lookup('env', 'HOME') }}/.local/bin/pi";
                executable = "${pkgs.bash}/bin/bash";
              };
            }
          ];
        }
      ];
    };
  };
}
