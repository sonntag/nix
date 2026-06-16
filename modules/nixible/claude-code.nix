{inputs, ...}: let
  # Shared playbook definition, consumed both by the `nix run` app and by the
  # home-manager activation hook below, so the two can never drift apart.
  mkPlaybook = pkgs: {
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
in {
  imports = [inputs.nixible.flakeModule];

  # Manual invocation: `nix run .#nixible:claude-code`
  perSystem = {pkgs, ...}: {
    nixible.claude-code = mkPlaybook pkgs;
  };

  # An aspect that installs Claude Code via its native installer on
  # activation. Include it into any aspect that wants it, e.g.
  # `den.aspects.justin.includes = [den.aspects.claude-code];`.
  den.aspects.claude-code.homeManager = {
    lib,
    pkgs,
    ...
  }: let
    cli = (inputs.nixible.lib {inherit pkgs lib;}).mkNixibleCli (mkPlaybook pkgs);
  in {
    home.activation.installClaudeCode = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD ${cli}/bin/nixible
    '';
  };
}
