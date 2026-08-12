{
  den,
  inputs,
  lib,
  ...
}: let
  hostTargets = lib.concatMap (
    hosts:
      lib.concatMap (
        host:
          map (user: {
            name = "${user.userName}@${host.name}";
            inherit (host) system;
            aspect = let
              userEntity = den.lib.resolveEntity "user" {inherit host user;};
            in
              # A user entity resolved as a flake output has no parent host
              # walk for host-aspects to project from, so include the concrete
              # host aspect explicitly while retaining the user's full entity
              # policy chain and context.
              userEntity
              // {
                includes = (userEntity.includes or []) ++ [host.aspect];
              };
          }) (builtins.attrValues host.users)
      ) (builtins.attrValues hosts)
  ) (builtins.attrValues den.hosts);

  homeTargets = lib.concatMap (
    homes:
      map (home: {
        name = "${home.userName}@${home.system}";
        inherit (home) system;
        aspect = den.lib.resolveEntity "home" {inherit home;};
      }) (builtins.attrValues homes)
  ) (builtins.attrValues den.homes);

  targets = hostTargets ++ homeTargets;
in {
  # Nixible is a first-class Den class. Playbooks can therefore be contributed,
  # extended, disabled, or replaced by any aspect in a target's policy chain.
  den.classes.nixible.description = "Imperative playbooks resolved for a Den target";

  perSystem = {
    pkgs,
    system,
    ...
  }: let
    nixible = inputs.nixible.lib {inherit pkgs lib;};

    playbookType = lib.types.submoduleWith {
      modules = [
        nixible.module
        {
          options.enable = lib.mkOption {
            type = lib.types.bool;
            default = true;
            description = "Whether this playbook applies to the resolved target.";
          };
        }
      ];
      specialArgs = {inherit pkgs;};
    };

    mkTargetCli = target: let
      resolvedModule = den.lib.aspects.resolve "nixible" target.aspect;
      evaluated = lib.evalModules {
        specialArgs = {inherit pkgs;};
        modules = [
          {
            config._module.freeformType = lib.types.lazyAttrsOf playbookType;
          }
          resolvedModule
        ];
      };
      enabled = lib.filterAttrs (_: playbook: playbook.enable) evaluated.config;
      playbooks = builtins.attrValues enabled;
    in
      nixible.mkNixibleCli {
        dependencies = lib.unique (lib.concatMap (playbook: playbook.dependencies) playbooks);
        collections = lib.foldl' lib.recursiveUpdate {} (map (playbook: playbook.collections) playbooks);
        playbook = lib.concatMap (playbook: playbook.playbook) playbooks;
      };

    systemTargets = builtins.filter (target: target.system == system) targets;
  in {
    apps = builtins.listToAttrs (map (target: let
        cli = mkTargetCli target;
      in {
        name = "nixible:${target.name}";
        value = {
          type = "app";
          program = lib.getExe cli;
          meta.description = "Apply Nixible policies for ${target.name}";
        };
      })
      systemTargets);
  };
}
