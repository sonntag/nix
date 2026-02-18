{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
}:
buildGoModule rec {
  pname = "sidecar";
  version = "0.71.1";

  src = fetchFromGitHub {
    owner = "marcus";
    repo = "sidecar";
    tag = "v${version}";
    hash = "sha256-LqpqNQ56tKXqEKbUrMxBkiGOzklGaqx8SCTEGIwE43k=";
  };

  nativeCheckInputs = [git];

  preCheck = ''
    export HOME=$TMPDIR
    git config --global user.email "test@test.com"
    git config --global user.name "Test"
  '';

  vendorHash = "sha256-R/AjNJ4x4t1zXXzT+21cjY+9pxs4DVXU4xs88BQvHx4=";

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  subPackages = ["cmd/sidecar"];

  meta = with lib; {
    description = "TUI companion for CLI-based AI coding agents";
    homepage = "https://github.com/marcus/sidecar";
    license = licenses.mit;
    mainProgram = "sidecar";
  };
}
