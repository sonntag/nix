{...}: {
  perSystem = {pkgs, ...}: let
    setupSsh = pkgs.writeShellApplication {
      name = "setup-ssh";
      runtimeInputs = [pkgs.coreutils pkgs.openssh];
      text = ''
        usage() {
          cat <<'EOF'
        Usage: setup-ssh

        Create a local, per-device Ed25519 SSH key when one is absent. The key
        remains outside the Nix store and this flake; only SSH client policy is
        managed declaratively.
        EOF
        }

        case "''${1:-}" in
          -h | --help)
            usage
            exit 0
            ;;
          "") ;;
          *)
            printf 'error: unknown argument: %s\n' "$1" >&2
            usage >&2
            exit 2
            ;;
        esac

        ssh_dir="$HOME/.ssh"
        ssh_key_file="''${SSH_KEY_FILE:-$ssh_dir/id_ed25519}"
        install -d -m 0700 "$ssh_dir"

        if [ -e "$ssh_key_file" ]; then
          if [ ! -f "$ssh_key_file.pub" ]; then
            printf 'error: %s exists but its public key is missing\n' "$ssh_key_file" >&2
            exit 1
          fi
          printf 'Using existing device SSH key at %s\n' "$ssh_key_file"
        elif [ -e "$ssh_key_file.pub" ]; then
          printf 'error: refusing to overwrite orphaned public key %s\n' "$ssh_key_file.pub" >&2
          exit 1
        else
          device_name="$(uname -n | cut -d. -f1)"
          user_name="$(id -un)"
          printf 'Generating per-device SSH key at %s\n' "$ssh_key_file"
          printf 'Choose a passphrase when prompted; the private key remains local.\n'
          ssh-keygen -t ed25519 -a 100 -C "$user_name@$device_name" -f "$ssh_key_file"
        fi

        chmod 0600 "$ssh_key_file"
        chmod 0644 "$ssh_key_file.pub"

        if [ "$(uname -s)" = Darwin ]; then
          /usr/bin/ssh-add --apple-use-keychain "$ssh_key_file"
        elif [ -n "''${SSH_AUTH_SOCK:-}" ]; then
          ssh-add "$ssh_key_file"
        else
          printf 'No SSH agent detected; add %s to an agent before use.\n' "$ssh_key_file"
        fi

        printf '\nPublic SSH key for this device:\n'
        cat "$ssh_key_file.pub"
        cat <<'EOF'

        Add this public key to GitHub before using SSH push URLs:
          https://github.com/settings/ssh/new
        EOF
      '';
    };

    sopsStatus = pkgs.writeShellApplication {
      name = "sops-status";
      runtimeInputs = [pkgs.age pkgs.sops];
      text = ''
        check=false

        usage() {
          cat <<'EOF'
        Usage: sops-status [--check]

        Print the device's sops-nix age recipient. With --check, also verify
        that it can decrypt the secrets required by the wrath policy.
        EOF
        }

        while [ "$#" -gt 0 ]; do
          case "$1" in
            --check) check=true ;;
            -h | --help)
              usage
              exit 0
              ;;
            *)
              printf 'error: unknown argument: %s\n' "$1" >&2
              usage >&2
              exit 2
              ;;
          esac
          shift
        done

        case "$(uname -s)" in
          Darwin)
            age_key_file="$HOME/Library/Application Support/sops/age/keys.txt"
            ;;
          Linux)
            config_home="''${XDG_CONFIG_HOME:-$HOME/.config}"
            age_key_file="$config_home/sops/age/keys.txt"
            ;;
          *)
            printf 'error: unsupported operating system: %s\n' "$(uname -s)" >&2
            exit 1
            ;;
        esac

        if [ ! -f "$age_key_file" ]; then
          cat >&2 <<EOF
        No SOPS age key exists at:
          $age_key_file

        Activate a secret-bearing target first (currently wrath). sops-nix will
        generate the key because sops.age.generateKey is enabled.
        EOF
          exit 1
        fi

        age_recipient="$(age-keygen -y "$age_key_file")"
        printf 'SOPS age recipient for this device:\n%s\n' "$age_recipient"

        if "$check"; then
          if ! SOPS_AGE_KEY_FILE="$age_key_file" \
            sops decrypt --output /dev/null ${../../modules/programs/macwhisper/secrets.yaml}; then
            cat >&2 <<EOF

        This recipient is not enrolled for the wrath secrets. On an enrolled
        machine, add it to .sops.yaml, then run:

          sops updatekeys modules/programs/macwhisper/secrets.yaml

        Commit and push the re-encrypted file before activating wrath.

        Recipient: $age_recipient
        EOF
            exit 1
          fi
          printf 'SOPS decryption check succeeded.\n'
        fi
      '';
    };
  in {
    apps = {
      setup-ssh = {
        type = "app";
        program = "${setupSsh}/bin/setup-ssh";
        meta.description = "Create a local per-device SSH identity";
      };
      sops-status = {
        type = "app";
        program = "${sopsStatus}/bin/sops-status";
        meta.description = "Show or verify the sops-nix age identity";
      };
    };
  };
}
