# Adding more hosts
There are a few steps to adding more hosts. This guide will walk you through the process.

## Step 1: Create a new host directory
Create a new directory in the `hosts` directory with the name of the host. This directory should contain the following files:

- `hardware-configuration.nix`
- `os.nix`
- `disko.nix`
- `home.nix`

## Step 2: `hardware-configuration.nix`
This file is specific to the hardware of the host. This file can be generated using the `nixos-generate-config` command. This file should be placed in the `hosts/<host>` directory.

## Step 3: `home.nix`
This file is specific to the user level configuration of the host. This file should import modules from the `home` directory and specify everything that should be configured and installed on the user level.

It usually only contains imports, every file should import `home/common.nix` as that configures home-manager that is used to manage user level packages.

Use this as a template: 
```nix
{...}: {
    imports = [
        ../../home/common.nix
        <other imports>
    ];
}
```

For reference see [hosts/skein/home.nix](../hosts/skein/home.nix)

## Step 5: `disko.nix`
This file is specific to the disk configuration of the host. This file usually mimics the [hybrid.nix](https://github.com/nix-community/disko/blob/master/example/hybrid.nix) file from the disko repository. To get started, copy the `hybrid.nix` file from the disko repository (or copy `skein/disko.nix` from this repository) and modify it to fit the host's disk configuration.

Usually the only modification necessary is to change the `device` designation. This should be set to the device that the host's root partition is on. This can be found by running `lsblk` on the host, just boot into the minimal installer and run `lsblk` to find the device.
