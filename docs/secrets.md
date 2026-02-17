# Secrets Management with sops-nix

## Overview

Secrets are managed using [sops-nix](https://github.com/Mic92/sops-nix). Secrets are stored encrypted in the repository (`secrets/secrets.yaml`) using [age](https://github.com/FiloSottile/age) encryption. Each host's age key is derived from its SSH host key, so no extra key management is needed.

At system activation (`nixos-rebuild switch` or `darwin-rebuild switch`), sops-nix decrypts the secrets to `/run/secrets/<name>`. Modules reference these decrypted paths.

## Currently Managed Secrets

| Secret | Path when decrypted | Used by |
|--------|-------------------|---------|
| `wakatime_api_key` | `/run/secrets/wakatime_api_key` | `~/.wakatime.cfg` via `api_key_vault_cmd` |
| `git_credentials` | `/run/secrets/git_credentials` | `git credential.helper = "store --file=..."` |
| `ssh_private_key` | `~/.ssh/id_ed25519` | SSH client (sops decrypts directly to this path) |

## Initial Setup on a New Host

### 1. Ensure the host key exists

Generate it with:
```sh
mkdir -p ~/.config/sops/age
nix-shell -p age --run "age-keygen -o ~/.config/sops/age/keys.txt"
chmod 600 ~/.config/sops/age/keys.txt
```

### 2. Get the age public key

```sh
cat ~/.config/sops/age/keys.txt | grep age | awk '{print $4}'
```

This outputs something like `age1abc123...`.

### 3. Add the key to `.sops.yaml`

Edit `.sops.yaml` at the repo root. Add the key with an anchor:
```yaml
keys:
  - &myhost age1abc123...
```

And add `*myhost` to the age list under `creation_rules`.

### 4. Re-encrypt secrets

```sh
sops updatekeys secrets/secrets.yaml
```

This re-encrypts the file so the new host can decrypt it.

## Adding a New Secret

### 1. Edit the encrypted secrets file

```sh
sops secrets/secrets.yaml
```

This opens your `$EDITOR` with the decrypted contents. Add a new key:
```yaml
wakatime_api_key: my-api-key
git_credentials: https://user:token@github.com
ssh_private_key: |
  -----BEGIN OPENSSH PRIVATE KEY-----
  ...
  -----END OPENSSH PRIVATE KEY-----
my_new_secret: secret-value
```

Save and close — sops re-encrypts automatically.

### 2. Declare the secret in sops modules

Add to both `modules/nixos/sops.nix` and `modules/darwin/sops.nix`:
```nix
secrets = {
  # ... existing secrets ...
  my_new_secret = {
    owner = username;
  };
};
```

### 3. Reference the decrypted path

In the consuming module, use `/run/secrets/my_new_secret`:
```nix
environment.variables.MY_SECRET_FILE = "/run/secrets/my_new_secret";
```

### 4. Rebuild

```sh
make rebuild
```

## Creating the Secrets File for the First Time

Before any secrets can be decrypted, you need at least one valid age key in `.sops.yaml`. Once you have real keys configured:

```sh
# Create and edit the secrets file
sops secrets/secrets.yaml
```

Add the expected keys (see "Currently Managed Secrets" above), save, and commit the encrypted file.

## Troubleshooting

### "No key found" during rebuild
The host's SSH ed25519 key doesn't match any key in `.sops.yaml`. Run `ssh-to-age` on the host and verify the public key matches.

### Secrets file doesn't exist
Create it with `sops secrets/secrets.yaml`. You need at least one valid age key in `.sops.yaml` first.

### Permission denied reading a secret
Check the `owner` and `mode` settings in the sops module. Secrets default to `root:root 0400`.
