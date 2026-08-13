{
  den.default.darwin = {
    lib,
    pkgs,
    ...
  }: let
    appBundle = pkgs.kanata-app;
    appBundleId = appBundle.bundleId;
    appDst = "/Applications/Nix Apps/Kanata.app";
    legacyAppDst = "/Applications/Kanata.app";
    kanataLauncher = "${appDst}/Contents/MacOS/Kanata";
    setupAgentLabel = "${appBundleId}.setup";
    configDir = "/Library/Application Support/Kanata";
    configDst = "${configDir}/kanata.kbd";
    karabinerManager = "/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager";
    karabinerDaemon = "/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon";

    signingIdentity = "Kanata Local Code Signing";
    signingKeychain = "/Library/Keychains/System.keychain";
    signingStateDir = "/var/db/kanata-signing";
    signingCertificate = "${signingStateDir}/certificate.der";

    # Kanata 1.13 switched its karabiner-driverkit client from protocol 5 to
    # protocol 7. The matching DriverKit package must be upgraded atomically.
    karabinerDriver =
      if lib.versionOlder pkgs.kanata.version "1.13.0"
      then {
        version = "6.2.0";
        hash = "sha256-noxGI58HSBYSQeQkRIV5ASJOXIL1tYoXMd9McL8HNqg=";
      }
      else {
        version = "8.0.0";
        hash = "sha256-DUEupJYTtwqYHYFkYdwwGbhKlln94KFWk5aXKDphp6w=";
      };

    karabinerDriverPkg = pkgs.fetchurl {
      url = "https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${karabinerDriver.version}/Karabiner-DriverKit-VirtualHIDDevice-${karabinerDriver.version}.pkg";
      inherit (karabinerDriver) hash;
    };

    createSigningIdentity = pkgs.writeShellApplication {
      name = "kanata-create-signing-identity";
      runtimeInputs = [pkgs.openssl];
      text = ''
        identity=${lib.escapeShellArg signingIdentity}
        keychain=${lib.escapeShellArg signingKeychain}
        stateDir=${lib.escapeShellArg signingStateDir}
        certificateDer=${lib.escapeShellArg signingCertificate}

        if [ "$(/usr/bin/id -u)" -ne 0 ]; then
          echo "error: run this command with sudo" >&2
          exit 1
        fi

        if /usr/bin/security find-identity -v -p codesigning "$keychain" |
          /usr/bin/grep -Fq "\"$identity\""; then
          echo "Kanata signing identity already exists."
          exit 0
        fi

        if /usr/bin/security find-certificate -c "$identity" "$keychain" \
          >/dev/null 2>&1; then
          echo "error: certificate '$identity' exists without a usable private key." >&2
          echo "Remove or repair that certificate before trying again." >&2
          exit 1
        fi

        workDir=$(/usr/bin/mktemp -d /private/tmp/kanata-signing.XXXXXX)
        trap '/bin/rm -rf "$workDir"' EXIT

        /bin/mkdir -p "$stateDir"
        /bin/chmod 700 "$stateDir"

        config="$workDir/openssl.cnf"
        /bin/cat > "$config" <<EOF
        [req]
        distinguished_name = distinguished_name
        x509_extensions = code_signing
        prompt = no

        [distinguished_name]
        CN = $identity

        [code_signing]
        basicConstraints = critical,CA:TRUE
        keyUsage = critical,digitalSignature,keyCertSign
        extendedKeyUsage = critical,codeSigning
        subjectKeyIdentifier = hash
        authorityKeyIdentifier = keyid:always
        EOF

        openssl req \
          -x509 \
          -newkey rsa:3072 \
          -sha256 \
          -days 3650 \
          -nodes \
          -config "$config" \
          -keyout "$workDir/private-key.pem" \
          -out "$workDir/certificate.pem"

        p12Password=$(openssl rand -hex 32)
        openssl pkcs12 \
          -export \
          -legacy \
          -inkey "$workDir/private-key.pem" \
          -in "$workDir/certificate.pem" \
          -name "$identity" \
          -passout "pass:$p12Password" \
          -out "$workDir/identity.p12"

        /usr/bin/security import "$workDir/identity.p12" \
          -k "$keychain" \
          -P "$p12Password" \
          -T /usr/bin/codesign

        /usr/bin/security add-trusted-cert \
          -d \
          -r trustRoot \
          -p codeSign \
          -k "$keychain" \
          "$workDir/certificate.pem"

        openssl x509 \
          -in "$workDir/certificate.pem" \
          -outform der \
          -out "$certificateDer"
        /usr/sbin/chown root:wheel "$certificateDer"
        /bin/chmod 644 "$certificateDer"

        if ! /usr/bin/security find-identity -v -p codesigning "$keychain" |
          /usr/bin/grep -Fq "\"$identity\""; then
          echo "error: the new Kanata signing identity is not usable by codesign." >&2
          exit 1
        fi

        echo "Created '$identity' in the System keychain."
      '';
    };

    kanataStatus = pkgs.writeShellApplication {
      name = "kanata-status";
      text = ''
        app=${lib.escapeShellArg appDst}
        expectedDriver=${lib.escapeShellArg karabinerDriver.version}
        driverManager=${lib.escapeShellArg karabinerManager}
        driverDaemon=${lib.escapeShellArg karabinerDaemon}

          echo "Kanata package: ${pkgs.kanata.version}"

          installedDriver=$(
            /usr/sbin/pkgutil \
              --pkg-info org.pqrs.Karabiner-DriverKit-VirtualHIDDevice \
              2>/dev/null |
              /usr/bin/awk '/^version:/ { print $2 }'
          )
          echo "DriverKit package: ''${installedDriver:-not installed} (expected $expectedDriver)"
          if [ -x "$driverManager" ] && [ -x "$driverDaemon" ]; then
            echo "DriverKit files: installed"
          else
            echo "DriverKit files: INCOMPLETE"
          fi

          if [ -d "$app" ]; then
            if /usr/bin/codesign --verify --deep --strict "$app" 2>/dev/null; then
              echo "Kanata.app signature: valid"
            else
              echo "Kanata.app signature: INVALID"
            fi
            /usr/bin/codesign -d -r- "$app" 2>&1 |
              /usr/bin/sed -n '/designated/,$p'
          else
            echo "Kanata.app: not installed"
          fi

          if /bin/launchctl print system/org.nixos.kanata >/dev/null 2>&1; then
            echo "Kanata daemon: loaded"
          else
            echo "Kanata daemon: not loaded"
          fi

          if /bin/launchctl print system/org.nixos.karabiner-vhiddaemon \
            >/dev/null 2>&1; then
            echo "DriverKit daemon: loaded"
          else
            echo "DriverKit daemon: not loaded"
          fi

          setupAgent="gui/$(/usr/bin/id -u)/${setupAgentLabel}"
          if /bin/launchctl print "$setupAgent" >/dev/null 2>&1; then
            echo "Kanata setup agent: loaded"
          else
            echo "Kanata setup agent: not loaded"
          fi

          echo
          echo "System extension status:"
          /usr/bin/systemextensionsctl list 2>/dev/null |
            /usr/bin/grep -i -C1 'org.pqrs.Karabiner-DriverKit-VirtualHIDDevice' ||
            echo "Karabiner DriverKit extension is not listed as active."
      '';
    };

    kanataLogs = pkgs.writeShellApplication {
      name = "kanata-logs";
      text = ''
        period="''${1:-1h}"
        /usr/bin/log show \
          --last "$period" \
          --info \
          --style compact \
          --predicate 'subsystem == "org.sonntag.kanata"'
      '';
    };
  in {
    environment.systemPackages = [
      pkgs.kanata
      appBundle
      createSigningIdentity
      kanataStatus
      kanataLogs
    ];

    environment.shellAliases = {
      kickstart-kanata = "sudo launchctl kickstart -k system/org.nixos.kanata";
      kill-kanata = "sudo launchctl stop system/org.nixos.kanata";
      open-kanata-setup = "open ${lib.escapeShellArg appDst}";
    };

    system.activationScripts.extraActivation.text = ''
      configDir=${lib.escapeShellArg configDir}
      configDst=${lib.escapeShellArg configDst}
      identity=${lib.escapeShellArg signingIdentity}
      keychain=${lib.escapeShellArg signingKeychain}
      certificate=${lib.escapeShellArg signingCertificate}
      legacyAppDst=${lib.escapeShellArg legacyAppDst}

      /bin/mkdir -p "$configDir" /Library/Logs/Kanata
      /usr/sbin/chown root:wheel "$configDir" /Library/Logs/Kanata
      /bin/chmod 755 "$configDir" /Library/Logs/Kanata

      # Remove only the legacy bundle installed by the previous version of
      # this module. The marker prevents deleting an unrelated Kanata app.
      if [ -f "$legacyAppDst/Contents/Resources/nix-store-path" ]; then
        echo "kanata: removing legacy $legacyAppDst"
        /bin/rm -rf "$legacyAppDst"
      fi

      if ! /usr/bin/security find-identity -v -p codesigning "$keychain" |
        /usr/bin/grep -Fq "\"$identity\""; then
        echo "kanata: creating the local code-signing identity"
        ${createSigningIdentity}/bin/kanata-create-signing-identity
      fi

      certificateNew="$certificate.new"
      /bin/mkdir -p ${lib.escapeShellArg signingStateDir}
      /bin/rm -f "$certificateNew"
      /usr/bin/security find-certificate \
        -c "$identity" \
        -p \
        "$keychain" |
        ${pkgs.openssl}/bin/openssl x509 -outform der -out "$certificateNew"
      /usr/sbin/chown root:wheel "$certificateNew"
      /bin/chmod 644 "$certificateNew"
      if [ ! -f "$certificate" ] ||
        ! /usr/bin/cmp -s "$certificateNew" "$certificate"; then
        echo "kanata: exporting the certificate used by the designated requirement"
        /bin/mv "$certificateNew" "$certificate"
      else
        /bin/rm -f "$certificateNew"
      fi

      if [ ! -f "$configDst" ] ||
        ! /usr/bin/cmp -s ${./kanata.kbd} "$configDst"; then
        echo "kanata: updating $configDst"
        /usr/bin/install -o root -g wheel -m 644 ${./kanata.kbd} "$configDst"
        /usr/bin/touch /var/run/kanata-restart-needed
      fi

      installedDriver=$(
        /usr/sbin/pkgutil \
          --pkg-info org.pqrs.Karabiner-DriverKit-VirtualHIDDevice \
          2>/dev/null |
          /usr/bin/awk '/^version:/ { print $2 }'
      )
      manager=${lib.escapeShellArg karabinerManager}
      driverDaemon=${lib.escapeShellArg karabinerDaemon}
      if [ "$installedDriver" != "${karabinerDriver.version}" ] ||
        [ ! -x "$manager" ] ||
        [ ! -x "$driverDaemon" ]; then
        echo "kanata: installing Karabiner DriverKit ${karabinerDriver.version} (was ''${installedDriver:-not installed})"
        /usr/sbin/installer -pkg ${karabinerDriverPkg} -target /

        if ! "$manager" forceActivate; then
          echo "kanata: DriverKit activation needs approval in System Settings." >&2
        fi

        /usr/bin/touch /var/run/kanata-driver-restart-needed
        /usr/bin/touch /var/run/kanata-restart-needed
      fi

    '';

    # nix-darwin copies application bundles from environment.systemPackages
    # into /Applications/Nix Apps. Sign that writable copy after the standard
    # application synchronization and before launchd is reloaded.
    system.activationScripts.applications.text = lib.mkAfter ''
      appDst=${lib.escapeShellArg appDst}
      bundleId=${lib.escapeShellArg appBundleId}
      engineRelativePath=${lib.escapeShellArg appBundle.engineRelativePath}
      identity=${lib.escapeShellArg signingIdentity}
      keychain=${lib.escapeShellArg signingKeychain}
      certificate=${lib.escapeShellArg signingCertificate}

      if [ ! -d "$appDst" ]; then
        echo "kanata: nix-darwin did not install $appDst" >&2
        exit 1
      fi

      certificateHash=$(
        ${pkgs.openssl}/bin/openssl x509 \
          -inform der \
          -in "$certificate" \
          -fingerprint \
          -sha1 \
          -noout |
          /usr/bin/awk -F= '{ print $2 }' |
          /usr/bin/tr -d :
      )
      if ! [[ "$certificateHash" =~ ^[0-9A-Fa-f]{40}$ ]]; then
        echo "kanata: could not determine the signing certificate hash" >&2
        exit 1
      fi

      identityHash=$(
        /usr/bin/security find-identity -v -p codesigning "$keychain" |
          /usr/bin/awk -v identity="$identity" \
            'index($0, "\"" identity "\"") { print $2; exit }'
      )
      if ! [[ "$identityHash" =~ ^[0-9A-Fa-f]{40}$ ]]; then
        echo "kanata: could not determine the code-signing identity hash" >&2
        exit 1
      fi
      if [ "''${certificateHash^^}" != "''${identityHash^^}" ]; then
        echo "kanata: signing certificate and private-key identity do not match" >&2
        exit 1
      fi

      requirement="anchor = H\"$certificateHash\" and identifier \"$bundleId\""
      designatedRequirement="designated => $requirement"

      echo "kanata: signing $appDst"
      /bin/chmod -R u+w "$appDst"

      if ! {
        /usr/bin/codesign \
          --force \
          --identifier "$bundleId" \
          --keychain "$keychain" \
          -r="$designatedRequirement" \
          --sign "$identityHash" \
          --timestamp=none \
          "$appDst/$engineRelativePath" &&
        /usr/bin/codesign \
          --force \
          --identifier "$bundleId" \
          --keychain "$keychain" \
          -r="$designatedRequirement" \
          --sign "$identityHash" \
          --timestamp=none \
          "$appDst" &&
        /usr/bin/codesign --verify --deep --strict -R="$requirement" \
          "$appDst" &&
        /usr/bin/codesign --verify --strict -R="$requirement" \
          "$appDst/$engineRelativePath"
      }; then
        /bin/chmod -R a-w "$appDst"
        echo "kanata: failed to sign $appDst" >&2
        exit 1
      fi

      /bin/chmod -R a-w "$appDst"
      /usr/bin/touch /var/run/kanata-restart-needed
    '';

    system.activationScripts.postActivation.text = ''
      if [ -f /var/run/kanata-driver-restart-needed ]; then
        /bin/rm -f /var/run/kanata-driver-restart-needed
        /bin/launchctl kickstart -k \
          system/org.nixos.karabiner-vhiddaemon 2>/dev/null || true
      fi

      if [ -f /var/run/kanata-restart-needed ]; then
        /bin/rm -f /var/run/kanata-restart-needed
        /bin/launchctl kickstart -k system/org.nixos.kanata \
          2>/dev/null || true
      fi
    '';

    launchd.daemons = {
      kanata.serviceConfig = {
        ProgramArguments = [
          kanataLauncher
          "--run-service"
          "--nodelay"
          "--no-wait"
          "--cfg"
          configDst
        ];
        UserName = "root";
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Interactive";
      };

      karabiner-vhiddaemon.serviceConfig = {
        ProgramArguments = [
          karabinerDaemon
        ];
        UserName = "root";
        RunAtLoad = true;
        KeepAlive = true;
        ProcessType = "Interactive";
        ThrottleInterval = 5;
      };
    };

    # Run the signed application in the primary user's GUI session so macOS
    # can attribute privacy prompts to Kanata.app. This is deliberately only a
    # setup check; Nix remains the sole owner of the privileged daemons.
    launchd.user.agents.kanata-setup.serviceConfig = {
      Label = setupAgentLabel;
      ProgramArguments = [
        kanataLauncher
        "--setup-if-needed"
      ];
      LimitLoadToSessionType = "Aqua";
      RunAtLoad = true;
      KeepAlive = false;
      ProcessType = "Interactive";
    };
  };
}
