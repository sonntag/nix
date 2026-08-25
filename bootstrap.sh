#!/bin/sh

set -eu

FLAKE_REF="${FLAKE_REF:-github:sonntag/nix}"
NIX_INSTALLER_URL="${NIX_INSTALLER_URL:-https://install.determinate.systems/nix}"

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

[ "$#" -eq 0 ] ||
  die "bootstrap does not accept a target; run 'nixctl setup' after it completes"

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

info "Installing nixctl from ${FLAKE_REF}"
"$NIX_BIN" profile add "${FLAKE_REF}#nixctl"

info "Bootstrap complete"
printf '\nOpen a new shell, then run the interactive machine setup:\n  nixctl setup\n'
