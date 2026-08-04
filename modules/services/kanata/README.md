# Kanata for macOS

This module installs Kanata as `/Applications/Nix Apps/Kanata.app` through
nix-darwin's standard application synchronization, signs the writable app copy
with a stable local identity, installs the compatible official Karabiner
DriverKit package, and runs both required background processes with launchd.

Kanata runs as root because the standalone Karabiner virtual HID daemon exposes
its IPC socket under `/Library/Application Support/org.pqrs/tmp/rootonly`.

## First installation

1. Rebuild the nix-darwin system.

   The activation creates a ten-year local code-signing identity named
   `Kanata Local Code Signing` in the System keychain. It then installs and
   signs `/Applications/Nix Apps/Kanata.app`.

   It also installs the official PQRS DriverKit package if the installed
   version does not match Kanata:

   - Kanata before 1.13.0 uses DriverKit 6.2.0.
   - Kanata 1.13.0 and newer uses DriverKit 8.0.0.

2. Open `Kanata.app`, or run `open-kanata-setup`.

   The app requests Input Monitoring and Accessibility access and provides
   buttons that open the relevant System Settings panes. The background
   LaunchDaemon runs through this same app executable, which makes the visible
   `Kanata` permission entry the responsible application for the embedded
   engine.

3. In **System Settings → General → Login Items & Extensions → Driver
   Extensions**, enable
   `org.pqrs.Karabiner-DriverKit-VirtualHIDDevice`.

   This approval is enforced by macOS and cannot be performed by nix-darwin.
   A restart may be required after replacing a previously deactivated driver.

4. Restart Kanata after approving everything:

   ```sh
   kickstart-kanata
   ```

## Updates

The app and its embedded Kanata engine use the same explicit designated code
requirement:

```text
anchor <local Kanata certificate> and identifier "org.sonntag.kanata"
```

As long as the signing certificate and bundle identifier remain unchanged,
updated binaries identify as the same application to macOS. nix-darwin first
synchronizes the bundle into `/Applications/Nix Apps`; the Kanata activation
hook then signs and validates that copy before launchd is reloaded.

DriverKit is maintained as part of the same activation. Nix pins the official
PQRS package hash and upgrades the driver together with the Kanata protocol
boundary.

## Operations

- `kanata-status` checks the package versions, code signature, launchd jobs,
  and system extension.
- `open-kanata-setup` requests or reviews privacy permissions.
- `kickstart-kanata` restarts Kanata.
- `kill-kanata` stops Kanata until launchd starts it again.
- Logs are in `/Library/Logs/Kanata/kanata.{out,err}.log`.
- The active configuration is copied to
  `/Library/Application Support/Kanata/kanata.kbd`.

The plain `kanata` command remains on `PATH` for configuration checks and
diagnostics.

## Signing recovery

`kanata-create-signing-identity` is idempotent and can be run manually with
`sudo`. Do not delete or rotate the signing certificate unless you are prepared
to grant Input Monitoring and Accessibility again.

If a certificate exists without its private key, the activation stops rather
than installing an unsigned app. Repair or remove that unusable certificate,
run `sudo kanata-create-signing-identity`, and rebuild.

## Upstream documentation

- [Kanata macOS setup](https://github.com/jtroo/kanata/blob/main/docs/setup-macos.md)
- [Karabiner DriverKit releases](https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases)
