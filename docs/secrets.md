# Secrets Management with sops-nix

## Overview

Secrets are managed using [sops-nix](https://github.com/Mic92/sops-nix). Secrets are stored encrypted in the repository (`secrets/secrets.yaml`) using [age](https://github.com/FiloSottile/age) encryption. Each host's age key is derived from its SSH host key, so no extra key management is needed.

At system activation (`nixos-rebuild switch` or `darwin-rebuild switch`), sops-nix decrypts the secrets to `/run/secrets/<name>`. Modules reference these decrypted paths.

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
sops updatekeys modules/shared/sops/secrets/*.yaml
```

This re-encrypts the file so the new host can decrypt it.

## Adding a New Secret

### 1. Edit the encrypted secrets file

```sh
sops modules/shared/sops/secrets/<secret-file>.yaml
```

This opens your `$EDITOR` with the decrypted contents. Add a new key, fx:
```yaml
my_new_secret: secret-value
```

Save and close — sops re-encrypts automatically.

### 2. Declare the secret in sops modules

Add to `modules/shared/sops/args.nix`
```nix
secrets = {
  # ... existing secrets ...
  my_new_secret = {
    owner = username;
  };
};
```

### 3. Reference the decrypted path

In the consuming module, use `config.sops.secret.my_new_secret` to get the path, e.g.:
```nix
environment.variables.MY_SECRET_FILE = "${config.sops.secret.my_new_secret}";
```

You can also write something like:
```nix
{
  config,
  ...
}: let
  secrets = config.sops.secrets;
in {
    environment.variables.MY_SECRET_FILE = if secrets ? my_new_secret.path
        then secrets.my_new_secret.path
        else "placeholder";
}
```

### 4. Rebuild

```sh
make rebuild
```

## Creating the Secrets File for the First Time

Before any secrets can be decrypted, you need at least one valid age key in `.sops.yaml`. Once you have real keys configured:

```sh
# Create and edit the secrets file
sops modules/shared/sops/secrets/secrets.yaml
```
