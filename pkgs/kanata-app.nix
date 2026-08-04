{
  lib,
  stdenv,
  kanata,
}: let
  bundleId = "org.sonntag.kanata";
in
  stdenv.mkDerivation {
    pname = "kanata-app";
    inherit (kanata) version;

    dontUnpack = true;

    buildPhase = ''
      runHook preBuild

      $CC \
        -fobjc-arc \
        -framework ApplicationServices \
        -framework Cocoa \
        ${./kanata-app/setup.m} \
        -o Kanata

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      contents="$out/Applications/Kanata.app/Contents"
      mkdir -p "$contents/MacOS" "$contents/Helpers" "$contents/Resources"

      install -m755 Kanata "$contents/MacOS/Kanata"
      install -m755 ${kanata}/bin/kanata "$contents/Helpers/kanata"
      install -m644 ${./kanata-app/Kanata.icns} "$contents/Resources/Kanata.icns"

      cat > "$contents/Info.plist" <<EOF
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "https://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>CFBundleIdentifier</key>
        <string>${bundleId}</string>
        <key>CFBundleName</key>
        <string>Kanata</string>
        <key>CFBundleDisplayName</key>
        <string>Kanata</string>
        <key>CFBundleIconFile</key>
        <string>Kanata</string>
        <key>CFBundleExecutable</key>
        <string>Kanata</string>
        <key>CFBundlePackageType</key>
        <string>APPL</string>
        <key>CFBundleInfoDictionaryVersion</key>
        <string>6.0</string>
        <key>CFBundleShortVersionString</key>
        <string>${kanata.version}</string>
        <key>CFBundleVersion</key>
        <string>${kanata.version}</string>
        <key>LSMinimumSystemVersion</key>
        <string>11.0</string>
        <key>NSHumanReadableCopyright</key>
        <string>Kanata is licensed under the LGPL-3.0 license.</string>
        <key>NSInputMonitoringUsageDescription</key>
        <string>Kanata needs Input Monitoring access to remap keyboard input.</string>
      </dict>
      </plist>
      EOF

      runHook postInstall
    '';

    passthru = {
      inherit bundleId;
      appPath = "Applications/Kanata.app";
      engineRelativePath = "Contents/Helpers/kanata";
    };

    meta = {
      description = "Kanata keyboard remapper packaged as a macOS application";
      inherit (kanata.meta) homepage license;
      platforms = lib.platforms.darwin;
    };
  }
