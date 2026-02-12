{
  lib,
  buildNpmPackage,
  fetchNpmDeps,
  fetchFromGitHub,
  npm-lockfile-fix,
}:
let
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "unhappychoice";
    repo = "mdts";
    tag = "v${version}";
    hash = "sha256-bNeW3rrFItNoRdoO5PwrcNQG5oTc+FkGBvMlOFIe3BY=";
  };

  npmDeps = fetchNpmDeps {
    inherit src;
    hash = "sha256-EXk1X319pGKYJRyE4D1774ep17aUDXSnapJUyPlXv4A=";
    nativeBuildInputs = [npm-lockfile-fix];
    postPatch = ''
      ${lib.getExe npm-lockfile-fix} package-lock.json
    '';
  };

  frontend = buildNpmPackage {
    pname = "mdts-frontend";
    inherit version src;
    sourceRoot = "${src.name}/packages/frontend";
    npmDepsHash = "sha256-6fydDKb8lMmKrP6RrA2BUbc7QRLp+80qCL+zcnv+XUs=";

    buildPhase = ''
      runHook preBuild
      node_modules/.bin/webpack --config webpack.config.js --output-path $TMPDIR/frontend-dist
      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r $TMPDIR/frontend-dist/* $out/
      runHook postInstall
    '';

    dontNpmInstall = true;
  };
in
buildNpmPackage {
  pname = "mdts";
  inherit version src npmDeps;

  postPatch = ''
    cp ${npmDeps}/package-lock.json package-lock.json
  '';

  buildPhase = ''
    runHook preBuild

    # Build backend TypeScript
    node_modules/.bin/tsc
    cp -R public/. dist/server/public

    # Copy pre-built frontend
    mkdir -p dist/frontend
    cp -r ${frontend}/* dist/frontend/

    runHook postBuild
  '';

  dontNpmInstall = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/node_modules/mdts
    cp -r dist $out/lib/node_modules/mdts/
    cp -r bin $out/lib/node_modules/mdts/
    cp -r node_modules $out/lib/node_modules/mdts/
    cp package.json $out/lib/node_modules/mdts/

    mkdir -p $out/bin
    ln -s $out/lib/node_modules/mdts/bin/mdts $out/bin/mdts

    runHook postInstall
  '';

  meta = with lib; {
    description = "A zero-configuration CLI tool for previewing local Markdown files in a browser";
    homepage = "https://github.com/unhappychoice/mdts";
    license = licenses.mit;
    mainProgram = "mdts";
  };
}
