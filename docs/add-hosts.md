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

## Step 6: `os.nix`
This file imports the above files and files that are common to hosts. When creating this file you should decide what kind of host it is. Fx is it a server, laptop og desktop. This will determine what modules to import. Different host types can be found in `modules/core-<type>.nix`.

Most hosts are of the desktop type, which itself extends the server type. The laptop type should be imported along with the desktop type if the host is a laptop.

You should also define the networking hostname in this file.

Use this as a template:
```nix
{...}: let
  diskPath = "/dev/sda";
in {
  imports = [
    (import ../../modules/core-desktop.nix {diskPath = diskPath; })
    ../../modules/core-laptop.nix
    ../../modules/services/bluetooth.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Disk configuration
    (import ./disko.nix { diskPath = diskPath; })
  ];

  networking.hostName = "skein"; # Define your hostname.
}
```

## Step 7: Configure it
In the `hosts/default.nix` file, add the new host to the list of hosts. This will configure it as a nixosConfiguration and create an installer for it.

The `default.nix` file should look something like this:
```nix
{...}: {
  ...

  configurations = {
    skein = {
      nixosModules = ./skein/os.nix;
      homeModules = ./skein/home.nix;
    };
    ...
    <add-host-here> = {
      nixosModules = ./<host>/os.nix;
      homeModules = ./<host>/home.nix;
    };
  };

  ...
}
```
