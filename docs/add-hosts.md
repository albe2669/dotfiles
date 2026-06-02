# Adding more hosts
There are a few steps to adding more hosts. This guide covers both NixOS (Linux) and Darwin (macOS) hosts.

Each host has an `info.nix` file that declares the host's `name` and `system` (e.g. `x86_64-linux` or `aarch64-darwin`). The build system automatically dispatches to `nixosSystem` or `darwinSystem` based on the `system` field.

## Adding a NixOS (Linux) Host

### Step 1: Create a new host directory
Create a new directory in the `hosts` directory with the name of the host. This directory should contain the following files:

- `info.nix`
- `default.nix`
- `hardware-configuration.nix`
- `os.nix`
- `disko.nix`
- `home.nix`

### Step 2: `info.nix`
This file is a plain attrset that identifies the host. It must contain `name` and `system`, and optionally `diskPath` for disko.

```nix
{
  name = "myhost";
  system = "x86_64-linux";
  diskPath = "/dev/sda";
}
```

### Step 3: `hardware-configuration.nix`
This file is specific to the hardware of the host. This file can be generated using the `nixos-generate-config` command. This file should be placed in the `hosts/<host>` directory.

After adding it to your hosts directory open it and delete everthing regarding the file system. If you want to save it to a different file for reference when creating `disko.nix`. The things to be deleted start with `filesystem.` or `swapDevices`

### Step 4: `home.nix`
This file is specific to the user level configuration of the host. This file should import modules from the `home` directory and specify everything that should be configured and installed on the user level.

Use this as a template:
```nix
{self, ...}: {
  hm.imports = [
    self.homeModules.home
    self.homeModules.fish
    # ... other home modules
  ];
}
```

For reference see [hosts/skein/home.nix](../hosts/skein/home.nix)

### Step 5: `disko.nix`
This file is specific to the disk configuration of the host. This file usually mimics the [hybrid.nix](https://github.com/nix-community/disko/blob/master/example/hybrid.nix) file from the disko repository. To get started, copy the `hybrid.nix` file from the disko repository (or copy `skein/disko.nix` from this repository) and modify it to fit the host's disk configuration.

Usually the only modification necessary is to change the `device` designation. This should be found by running `lsblk` on the host.

### Step 6: `default.nix`
This file imports the host's modules and handles the disko import:

```nix
let
  info = import ./info.nix;
in {
  imports = [
    ./os.nix
    ./home.nix
    ./hardware-configuration.nix
    (import ./disko.nix {diskPath = info.diskPath;})
  ];
}
```

### Step 7: `os.nix`
This file imports system-level modules. When creating this file you should decide what kind of host it is (server, laptop, desktop). Different host types can be found in `modules/nixos/core-<type>.nix`.

```nix
{self, config, ...}: {
  imports = [
    self.nixosModules.core-desktop
    # ... other nixos modules
  ];

  networking.hostName = config.opts.info.name;
}
```

### Step 8: Register the host
Add the host name to the `allHosts` list in `hosts/default.nix`. Since the `system` field in `info.nix` is `x86_64-linux`, it will automatically be built as a NixOS configuration.

### Step 9: Secrets setup
See [secrets.md](./secrets.md) for full details. In short:
1. Get the host's age public key: `ssh-to-age -i /etc/ssh/ssh_host_ed25519_key.pub`
2. Add it to `.sops.yaml` with a new anchor
3. Re-encrypt: `sops updatekeys secrets/secrets.yaml`

### Step 10: Build
```sh
make rebuild
# or
sudo nixos-rebuild switch --flake .#<host>
```

## Adding a Darwin (macOS) Host

### Step 1: Create a new host directory
Create a new directory in the `hosts` directory. A Darwin host needs:

- `info.nix`
- `default.nix`
- `os.nix`
- `home.nix`

Note: No `hardware-configuration.nix` or `disko.nix` needed for Darwin.

### Step 2: `info.nix`
```nix
{
  name = "mydarwinhost";
  system = "aarch64-darwin";  # or "x86_64-darwin" for Intel Macs
}
```

### Step 3: `default.nix`
```nix
{...}: {
  imports = [
    ./os.nix
    ./home.nix
  ];
}
```

### Step 4: `os.nix`
Import the darwin core module and any other darwin-specific modules:

```nix
{self, config, ...}: {
  imports = [
    self.darwinModules.core
  ];

  networking.hostName = config.opts.info.name;
}
```

### Step 5: `home.nix`
Import only cross-platform home modules (avoid Linux-specific ones like hyprland, dunst, etc.):

```nix
{self, ...}: {
  hm.imports = [
    self.homeModules.home
    self.homeModules.fish
    self.homeModules.git
    self.homeModules.lazygit
    self.homeModules.nvim
    self.homeModules.direnv
    self.homeModules.utils
    self.homeModules.yazi
    self.homeModules.zellij
  ];
}
```

### Step 6: Register the host
Add the host name to the `allHosts` list in `hosts/default.nix`. Since the `system` field in `info.nix` contains `-darwin`, it will automatically be built as a Darwin configuration.

### Step 7: Secrets setup
See [secrets.md](./secrets.md) for full details. In short:

### Step 8: Install

Assuming a completely fresh macOS installation, you will need to first install Nix and git:
```sh
sh <(curl -L https://nixos.org/nix/install)
nix-shell -p git
mkdir -p ~/Documents/Coding/Other/dotfiles
cd ~/Documents/Coding/Other/dotfiles
git clone <repo-url> .
```

Then you can run the initial darwin-rebuild command:
```sh
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#<host>
```

### Step 9: Subsequent builds
After the initial setup, you can use `darwin-rebuild` for subsequent builds:
```sh
make rebuild
# or
darwin-rebuild switch --flake .#
```
