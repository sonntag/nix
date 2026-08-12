#!/bin/sh

set -eu

FLAKE_REF="${FLAKE_REF:-github:sonntag/nix}"
NIX_INSTALLER_URL="${NIX_INSTALLER_URL:-https://install.determinate.systems/nix}"
EXPECTED_USER="justin"

info() {
  printf '\n==> %s\n' "$1"
}

die() {
  printf '\nerror: %s\n' "$1" >&2
  exit 1
}

load_nix() {
  if command -v nix >/dev/null 2>&1; then
    NIX_BIN="$(command -v nix)"
    return 0
  fi

  for profile_script in \
    /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh \
    /nix/var/nix/profiles/default/etc/profile.d/nix.sh
  do
    if [ -r "$profile_script" ]; then
      # shellcheck disable=SC1090
      . "$profile_script"
      break
    fi
  done

  if command -v nix >/dev/null 2>&1; then
    NIX_BIN="$(command -v nix)"
  elif [ -x /nix/var/nix/profiles/default/bin/nix ]; then
    NIX_BIN="/nix/var/nix/profiles/default/bin/nix"
  else
    return 1
  fi
}

detect_target() {
  kernel="$(uname -s)"
  machine="$(uname -m)"

  case "$kernel" in
    Darwin)
      [ "$machine" = "arm64" ] ||
        die "this flake supports macOS on Apple Silicon only (found $machine)"
      OS_FAMILY="darwin"
      NIX_SYSTEM="aarch64-darwin"
      ;;
    Linux)
      [ -r /etc/os-release ] || die "cannot identify this Linux distribution"
      # shellcheck disable=SC1091
      . /etc/os-release
      [ "${ID:-}" = "ubuntu" ] ||
        die "this bootstrap supports Ubuntu only (found ${ID:-unknown})"

      case "$machine" in
        x86_64) NIX_SYSTEM="x86_64-linux" ;;
        aarch64 | arm64) NIX_SYSTEM="aarch64-linux" ;;
        *) die "this flake does not have an Ubuntu configuration for $machine" ;;
      esac
      OS_FAMILY="linux"
      ;;
    *)
      die "this bootstrap supports only macOS and Ubuntu (found $kernel)"
      ;;
  esac
}

select_activation() {
  requested="${1:-${BOOTSTRAP_TARGET:-}}"

  if [ -z "$requested" ] && [ "$OS_FAMILY" = "darwin" ] && [ -t 1 ]; then
    printf '\nChoose what to activate:\n' >/dev/tty
    printf '  1) Home Manager only (recommended for a new machine)\n' >/dev/tty
    printf '  2) wrath (full nix-darwin configuration)\n' >/dev/tty
    printf 'Selection [1]: ' >/dev/tty
    IFS= read -r requested </dev/tty || requested=""
  fi

  case "${requested:-home}" in
    1 | home | home-manager)
      ACTIVATION="home-manager"
      ;;
    2 | wrath)
      [ "$OS_FAMILY" = "darwin" ] ||
        die "the wrath configuration can only be activated on macOS"
      ACTIVATION="darwin"
      DARWIN_CONFIGURATION="wrath"
      ;;
    huginn)
      die "huginn is a reusable NixOS module, not an activatable nixosConfiguration in this flake"
      ;;
    *)
      die "unknown activation '$requested' (expected 'home' or 'wrath')"
      ;;
  esac
}

select_ssh_setup() {
  requested="${BOOTSTRAP_SSH_KEY:-}"

  if [ -z "$requested" ] && [ -t 1 ]; then
    printf '\nSet up a local, per-device SSH key? [y/N]: ' >/dev/tty
    IFS= read -r requested </dev/tty || requested=""
  fi

  case "${requested:-no}" in
    y | Y | yes | YES | true | 1)
      SETUP_SSH_KEY=1
      ;;
    n | N | no | NO | false | 0)
      SETUP_SSH_KEY=0
      ;;
    *)
      die "unknown SSH key choice '$requested' (expected 'yes' or 'no')"
      ;;
  esac
}

install_determinate_nix() {
  installer="$(mktemp "${TMPDIR:-/tmp}/determinate-nix-installer.XXXXXX")"
  trap 'rm -f "$installer"' EXIT HUP INT TERM

  info "Downloading the Determinate Nix installer"
  curl --proto '=https' --tlsv1.2 --fail --silent --show-error --location \
    "$NIX_INSTALLER_URL" --output "$installer"

  info "Installing Determinate Nix"
  sh "$installer" install --no-confirm

  rm -f "$installer"
  trap - EXIT HUP INT TERM
}

detect_target
select_activation "${1:-}"
select_ssh_setup

current_user="$(id -un)"
[ "$current_user" = "$EXPECTED_USER" ] ||
  die "this flake configures user '$EXPECTED_USER'; run the bootstrap as that user, not '$current_user'"

command -v curl >/dev/null 2>&1 || die "curl is required"

if load_nix; then
  nix_version="$($NIX_BIN --version)"
else
  NIX_BIN=""
  nix_version=""
fi

case "$nix_version" in
  *"Determinate Nix"*)
    info "Determinate Nix is already installed ($nix_version)"
    ;;
  *)
    if [ -n "$nix_version" ]; then
      info "Replacing the existing Nix installation with Determinate Nix ($nix_version)"
    fi
    install_determinate_nix
    hash -r 2>/dev/null || true
    load_nix || die "Determinate Nix was installed, but nix is not available in this shell"

    nix_version="$($NIX_BIN --version)"
    case "$nix_version" in
      *"Determinate Nix"*) ;;
      *) die "the installed nix does not identify itself as Determinate Nix: $nix_version" ;;
    esac
    ;;
esac

if [ "$SETUP_SSH_KEY" -eq 1 ]; then
  info "Creating a local SSH identity"
  "$NIX_BIN" run "${FLAKE_REF}#setup-ssh"
fi

case "$ACTIVATION" in
  darwin)
    darwin_rebuild="${FLAKE_REF}#darwinConfigurations.${DARWIN_CONFIGURATION}.config.system.build.darwin-rebuild"

    info "Activating macOS configuration ${DARWIN_CONFIGURATION} from ${FLAKE_REF}"
    sudo "$NIX_BIN" run "$darwin_rebuild" -- \
      switch --flake "${FLAKE_REF}#${DARWIN_CONFIGURATION}"

    # On a new machine, the sops-nix launch agent creates the age key and then
    # fails to decrypt until its public recipient is enrolled. Give launchd a
    # moment to write the key before reporting that expected bootstrap boundary.
    age_key_file="$HOME/Library/Application Support/sops/age/keys.txt"
    attempts=0
    while [ ! -f "$age_key_file" ] && [ "$attempts" -lt 10 ]; do
      sleep 1
      attempts=$((attempts + 1))
    done

    info "Verifying SOPS enrollment"
    "$NIX_BIN" run "${FLAKE_REF}#sops-status" -- --check
    nixible_target="${EXPECTED_USER}@${DARWIN_CONFIGURATION}"
    ;;
  home-manager)
    home_configuration="${HOME_CONFIGURATION:-justin@${NIX_SYSTEM}}"

    info "Building Home Manager configuration ${home_configuration} from ${FLAKE_REF}"
    generation="$($NIX_BIN build --no-link --print-out-paths \
      "${FLAKE_REF}#homeConfigurations.\"${home_configuration}\".activationPackage")"
    [ -x "$generation/activate" ] ||
      die "Home Manager activation script was not produced at $generation/activate"

    info "Activating Home Manager configuration ${home_configuration}"
    "$generation/activate"
    nixible_target="${EXPECTED_USER}@${NIX_SYSTEM}"

    # Standalone targets currently own no encrypted secrets, so sops-nix does
    # not create an age key for them. If one already exists, surface its public
    # recipient without making it a prerequisite for Home Manager.
    case "$OS_FAMILY" in
      darwin) age_key_file="$HOME/Library/Application Support/sops/age/keys.txt" ;;
      linux) age_key_file="${XDG_CONFIG_HOME:-$HOME/.config}/sops/age/keys.txt" ;;
    esac
    if [ -f "$age_key_file" ]; then
      info "Current SOPS identity"
      "$NIX_BIN" run "${FLAKE_REF}#sops-status"
    fi
    ;;
esac

info "Applying Nixible policies for ${nixible_target}"
"$NIX_BIN" run "${FLAKE_REF}#nixible:${nixible_target}"

info "Bootstrap complete"
