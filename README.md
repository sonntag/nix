## TODO

## Bootstrap a new machine

Run the bootstrap as the `justin` user on Apple Silicon macOS or x86-64/ARM64
Ubuntu. On macOS it prompts for either a Home Manager-only setup or the full
`wrath` nix-darwin configuration. Ubuntu activates Home Manager only.

```sh
curl --proto '=https' --tlsv1.2 -fsSL https://raw.githubusercontent.com/sonntag/nix/main/bootstrap.sh | sh
```

Home Manager is the safe default when the script cannot prompt. A target can
also be selected explicitly:

```sh
# Home Manager only
curl --proto '=https' --tlsv1.2 -fsSL https://raw.githubusercontent.com/sonntag/nix/main/bootstrap.sh |
  sh -s -- home

# Full macOS configuration
curl --proto '=https' --tlsv1.2 -fsSL https://raw.githubusercontent.com/sonntag/nix/main/bootstrap.sh | sh -s -- wrath
```

The script installs Determinate Nix when necessary and activates the selected
configuration directly from GitHub. The first Home Manager activation checks
the flake out to `~/.local/share/sonntag-nix`, ready to edit with Neovim.
Subsequent rebuilds can use:

```sh
# macOS
drs

# Ubuntu (use aarch64-linux on ARM64)
home-manager switch --flake ~/.local/share/sonntag-nix#justin@x86_64-linux
```

`huginn` is exported as a reusable NixOS module for a consuming infrastructure
flake, rather than as `nixosConfigurations.huginn`, so it is not a bootstrap
target in this repository.

### Move from Home Manager to a full machine configuration

No migration or Home Manager uninstall is required. After adding the new host
to the local flake, activate it with its nix-darwin configuration name:

```sh
flake=~/.local/share/sonntag-nix
host=my-new-host

sudo nix run "$flake#darwinConfigurations.$host.config.system.build.darwin-rebuild" -- switch --flake "$flake#$host"
```

The nix-darwin activation then manages Home Manager as part of the machine
configuration. Once it succeeds, use the machine rebuild rather than continuing
to switch the standalone Home Manager profile independently.

To test another branch or fork before it is merged, override the flake source:

```sh
curl --proto '=https' --tlsv1.2 -fsSL https://raw.githubusercontent.com/sonntag/nix/main/bootstrap.sh | FLAKE_REF=github:sonntag/nix/my-branch sh
```

## Configuration diagram

Generate a Rosé Pine-themed diagram of the Den aspects that resolve into the
`wrath` Darwin, Home Manager, and user configurations:

```
nix run path:.#write-diagram
```

`just diagram` is available as a shortcut when `just` is installed.

This writes Mermaid and Graphviz source, an embeddable Markdown document, and a
rendered SVG to `diagrams/`. You can also build the SVG without copying it into
the repository with `nix build path:.#config-diagram`.

## Steps for adding new machine secrets

1. Create new age key on the machine

```
age-keygen -o ~/Library/Application Support/sops/age/keys.txt
```

2. Copy the public key and add it to .sops.yaml
1. Profit
