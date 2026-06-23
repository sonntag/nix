{inputs, ...}: {
  # Always-on aspect: declares `nixible.playbooks` and runs every declared
  # playbook. Include it once in your base user aspect; after that, ANY included
  # aspect can contribute playbooks via `nixible.playbooks.<name>`, and they
  # apply iff that aspect is part of the active configuration. The aspect name
  # has nothing to do with whether it carries a playbook.
  #
  # All enabled playbooks are merged into a SINGLE nixible CLI and run in one
  # `ansible-playbook` call (nixible's `playbook` field is itself a list of
  # plays). One activation hook, one ansible process startup, one log stream.
  # Plays run in alphabetical order of their `nixible.playbooks.<name>` key.
  den.aspects.nixible.homeManager = {
    config,
    lib,
    pkgs,
    ...
  }: let
    inherit (lib) types mkOption attrValues filterAttrs concatMap foldl' unique optionalAttrs hm;
    cfg = config.nixible.playbooks;
    enabled = attrValues (filterAttrs (_: pb: pb.enable) cfg);

    # Fold every enabled playbook into a single nixible config: concat the
    # plays, union the runtime deps, merge the Galaxy collections (last wins on
    # a key clash — keep versions consistent across playbooks).
    combined = {
      dependencies = unique (concatMap (pb: pb.dependencies) enabled);
      collections = foldl' (acc: pb: acc // pb.collections) {} enabled;
      playbook = concatMap (pb: pb.playbook) enabled;
    };

    cli = (inputs.nixible.lib {inherit pkgs lib;}).mkNixibleCli combined;

    playbookType = types.submodule {
      options = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Include this playbook in the activation run.";
        };
        dependencies = mkOption {
          type = types.listOf types.package;
          default = [];
          description = "Packages on PATH while the playbooks run.";
        };
        collections = mkOption {
          type = types.attrsOf (types.attrsOf types.str);
          default = {};
          description = "Ansible Galaxy collections (version + hash).";
        };
        playbook = mkOption {
          type = types.listOf types.attrs;
          description = "One or more Ansible plays, as a Nix data structure.";
        };
      };
    };
  in {
    options.nixible.playbooks = mkOption {
      type = types.attrsOf playbookType;
      default = {};
      description = "Nixible playbooks applied during home-manager activation.";
    };

    config.home.activation = optionalAttrs (enabled != []) {
      nixible = hm.dag.entryAfter ["writeBoundary"] ''
        $DRY_RUN_CMD ${cli}/bin/nixible
      '';
    };
  };
}
