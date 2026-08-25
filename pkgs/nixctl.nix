{
  coreutils,
  git,
  jq,
  nix-output-monitor,
  openssh,
  writeShellApplication,
}:
writeShellApplication {
  name = "nixctl";
  runtimeInputs = [
    coreutils
    git
    jq
    nix-output-monitor
    openssh
  ];
  text = builtins.readFile ../scripts/nixctl;
  meta.description = "Manage and set up Sonntag Nix configurations";
}
