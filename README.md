## TODO

## Steps for setting up

1. Install MacOS command line tools

```
xcode-select --install
```

2. Install determinate nix:

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
```

3. Apply flake

```
nix run nix-darwin -- switch --refresh --flake github:sonntag/nix#<hostname>
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
