---
name: manage-skills
description: Create, update, and manage Claude Code skills through the user's Nix flake configuration
---

# Managing Claude Code Skills

All Claude Code skills on this machine are managed declaratively through a Nix flake. Do not attempt to edit skill files in their installed locations — changes must go through the flake.

## Flake location

The Nix flake is at `~/Development/sonntag/nix` on all of this user's machines. Skills live under:

```
~/Development/sonntag/nix/modules/ai/claude-code/skills/<skill-name>/SKILL.md
```

Each skill is a directory containing a `SKILL.md` file. The directory name becomes the skill name.

Skills are registered in:
```
~/Development/sonntag/nix/modules/ai/claude-code/default.nix
```

## Creating a new skill

1. Create a directory for the skill:
   ```bash
   mkdir ~/Development/sonntag/nix/modules/ai/claude-code/skills/<skill-name>
   ```

2. Write the skill content in `SKILL.md` with the required frontmatter:
   ```markdown
   ---
   name: <skill-name>
   description: One-line description of what this skill does
   ---

   # Skill content here...
   ```

3. Register the skill in `default.nix` by adding it to the `skills` attrset:
   ```nix
   skills.<skill-name> = ./skills/<skill-name>;
   ```

4. Apply the change by switching to the new configuration (see below).

## Updating an existing skill

Edit the skill's `SKILL.md` file directly in the flake, then apply the change by switching the system.

## Applying changes (switching the system)

After creating or modifying a skill, rebuild and switch to the new configuration. On NixOS/nix-darwin machines, run the appropriate switch command from the flake directory or use the `drs` alias if available:

```bash
drs
```

Or explicitly:
```bash
# nix-darwin (macOS)
darwin-rebuild switch --flake ~/Development/sonntag/nix

# NixOS (Linux)
sudo nixos-rebuild switch --flake ~/Development/sonntag/nix
```

## Removing a skill

1. Delete the skill directory from `~/Development/sonntag/nix/modules/ai/claude-code/skills/<skill-name>/`
2. Remove its entry from `default.nix`
3. Switch the system to apply the change

## Important notes

- Skills are deployed to all machines that share this flake configuration.
- Never edit skill files outside of the flake — those files are managed by Nix and may be read-only or overwritten on the next switch.
