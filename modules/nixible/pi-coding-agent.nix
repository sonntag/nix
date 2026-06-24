# Installs the Pi coding agent on activation via its native installer. Attached
# to the `justin` aspect so it applies wherever justin is configured. Move this
# block to a different aspect to scope it.
#
# The installer is interactive when it can open /dev/tty (it shows a y/n menu
# and reads a keypress); with no controlling terminal it auto-installs without
# prompting. Whether home-manager activation has a reachable /dev/tty is
# environment-dependent and untested here — if a `darwin-rebuild switch` ever
# stalls on a pi prompt, fall back to the exact npm command the installer prints:
#   npm install -g --prefix ~/.local @earendil-works/pi-coding-agent
#
# Note: running the installer manually in a shell with GNU coreutils' `stty`
# first on PATH fails ("unable to perform all requested operations") because GNU
# stty mishandles macOS ttys. That's fixed separately by stripping GNU stty on
# Darwin (see modules/shell/utils.nix).
{
  den.aspects.justin.homeManager = {pkgs, ...}: {
    # Pi's launcher starts with `#!/usr/bin/env node`, so it needs a `node` on
    # PATH at *runtime*, not just during the install. The nodejs in the playbook
    # `dependencies` below is only on PATH during activation (so the installer's
    # npm can run); this puts the same Node on the interactive shell PATH so `pi`
    # actually runs. (Same nodejs_22 used to install, so the runtime matches.)
    home.packages = [pkgs.nodejs_22];

    nixible.playbooks.pi-coding-agent = {
      # The installer downloads via curl and installs via npm (Pi requires
      # Node >= 22.19). Pin curl/node/npm so the run is reproducible regardless
      # of what's on PATH at activation time.
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
              # curl/node/npm come from the pinned dependencies (captured via the
              # env PATH lookup); append the standard system bin dirs for anything
              # the installer shells out to (e.g. the native /bin/stty).
              environment.PATH = "{{ lookup('env', 'PATH') }}:/usr/bin:/bin:/usr/sbin:/sbin";
              # With a Nix-provided npm the global prefix is read-only, so the
              # installer falls back to ~/.local and drops the binary in
              # ~/.local/bin. `creates` makes this idempotent: skipped once that
              # binary exists, so it only hits the network on first install.
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
  };
}
