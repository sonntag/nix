{
  den,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: let
    diagram = inputs.den-diagram.lib;
    host = den.hosts.aarch64-darwin.wrath;
    classes = [
      "darwin"
      "homeManager"
      "user"
    ];

    captured = den.lib.capture.captureWithPathsWith {
      inherit classes;
      root = den.lib.resolveEntity "host" {inherit host;};
      ctx = {inherit host;};
    };

    hostGraph = diagram.context {
      inherit (captured) entries ctxTrace pathsByClass;
      name = host.name;
      direction = "LR";
    };

    rosePineTheme = diagram.themeFromBase16 {
      inherit pkgs;
      scheme = "rose-pine";
    };
    # Rose Pine's final base16 accent is a dark muted color. Replace it in the
    # diagram accent pool so Den's dark-label treatment remains readable.
    theme =
      rosePineTheme
      // {
        accentPool = with rosePineTheme.palette; [
          base08
          base09
          base0A
          base0B
          base0C
          base0D
          base0E
          base04
        ];
      };

    renderContext = diagram.renderContext {
      inherit pkgs theme;
      mermaidConfig = {
        layout = "elk";
        elk = {
          mergeEdges = true;
          nodePlacementStrategy = "BRANDES_KOEPF";
        };
        flowchart.wrappingWidth = 500;
      };
    };

    overviewGraph = diagram.graph.filterUserAspects hostGraph;
    mermaidSource = renderContext.renderDense.toMermaid overviewGraph;
    dotSource = renderContext.render.toDot overviewGraph;
    mermaid = pkgs.writeText "nix-config.mmd" mermaidSource;
    dot = pkgs.writeText "nix-config.dot" dotSource;
    svg = renderContext.dotSourceToSvg "nix-config" dotSource;
    markdown = pkgs.writeText "nix-config.md" ''
      # Nix configuration: ${host.name}

      Generated from Den's resolved aspect graph for the `darwin`,
      `homeManager`, and `user` classes. The SVG is rendered with Graphviz;
      the equivalent Mermaid source is included below.

      ![Resolved Nix configuration](./nix-config.svg)

      ```mermaid
      ${mermaidSource}
      ```
    '';

    writeDiagram = pkgs.writeShellScriptBin "write-diagram" ''
      set -euo pipefail

      project_root="$(${pkgs.git}/bin/git rev-parse --show-toplevel)"
      output_dir="$project_root/diagrams"
      mkdir -p "$output_dir"

      cat ${mermaid} > "$output_dir/nix-config.mmd"
      cat ${dot} > "$output_dir/nix-config.dot"
      cat ${svg} > "$output_dir/nix-config.svg"
      cat ${markdown} > "$output_dir/nix-config.md"

      echo "Wrote the Den diagram to $output_dir/"
    '';
  in {
    packages = {
      config-diagram = svg;
      config-diagram-source = mermaid;
      config-diagram-dot = dot;
      write-diagram = writeDiagram;
    };
  };
}
