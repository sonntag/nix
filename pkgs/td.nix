{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  sqlite,
}:
buildGoModule rec {
  pname = "td";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "marcus";
    repo = "td";
    tag = "v${version}";
    hash = "sha256-VwVg+b8nhGbv2RgxDOUOSwFCIZyhA/Wt3lT9NUzw6aU=";
  };

  vendorHash = "sha256-Rp0lhnBLJx+exX7VLql3RfthTVk3LLftD6n6SsSWzVY=";

  nativeCheckInputs = [git sqlite];

  preCheck = ''
    export HOME=$TMPDIR
    git config --global user.email "test@test.com"
    git config --global user.name "Test"
  '';

  ldflags = [
    "-s"
    "-w"
    "-X main.Version=${version}"
  ];

  meta = with lib; {
    description = "Minimalist CLI task manager for AI-assisted coding sessions";
    homepage = "https://github.com/marcus/td";
    license = licenses.mit;
    mainProgram = "td";
  };
}
