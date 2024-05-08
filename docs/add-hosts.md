# Adding more hosts
There are a few steps to adding more hosts. This guide will walk you through the process.

## Step 1: Create a new host directory
Create a new directory in the `hosts` directory with the name of the host. This directory should contain the following files:

- `info.nix`
- `hardware-configuration.nix`
- `os.nix`
- `disko.nix`
- `home.nix`

## Step 2: `hardware-configuration.nix`
This file is specific to the hardware of the host. This file can be generated using the `nixos-generate-config` command. This file should be placed in the `hosts/<host>` directory.

After adding it to your hosts directory open it and delete everthing regarding the file system. If you want to save it to a different file for reference when creating `disko.nix`. The things to be deleted start with `filesystem.` or `swapDevices`

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

## Step 6: `info.nix`
This file specifies details about the system that the rest of the dotfiles may need to identify and build on later. Be careful about what you import here as it will be imported early on in the process.

You should define the networking hostname in this file using the `name` variable

For skein it looks like this:
```nix
{...}: let
	name = "skein";
    diskPath = "/dev/sda";
	disko = import ./disko.nix { diskPath = diskPath; };
in {
	name = name;
	diskPath = diskPath;
	disko = disko;
}
```

## Step 7: `os.nix`
This file imports the above files and files that are common to hosts. When creating this file you should decide what kind of host it is. Fx is it a server, laptop og desktop. This will determine what modules to import. Different host types can be found in `modules/core-<type>.nix`.

Most hosts are of the desktop type, which itself extends the server type. The laptop type should be imported along with the desktop type if the host is a laptop.

Use this as a template:
```nix
{...}: let
	info = import ./info.nix {};
in {
  imports = [
    (import ../../modules/core-desktop.nix {diskPath = info.diskPath; })
    # Probably does nothing as it's a vm, but it tests if the installation is successful.
    ../../modules/core-laptop.nix
    ../../modules/services/bluetooth.nix

    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    info.disko
  ];

  networking.hostName = info.name; # Define your hostname.
}
```

### Step 7.1: Nvidia
If you have an Nvidia graphics card you should include `../../modules/core/nvidia.nix` in `os.nix`.

If you have a laptop with an Nvidia graphics card you should run `sudo lshw -c display` and find your bus ids. [See this wiki page for how](https://nixos.wiki/wiki/Nvidia#Laptop_Configuration:_Hybrid_Graphics_.28Nvidia_Optimus_PRIME.29) and paste them into you `os.nix` as follows:
```nix
hardware.nvidia.prime = {
    # Make sure to use the correct Bus ID values for your system!
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
};
```

## Step 8: Configure it
In the `hosts/default.nix` file, add the new host to the list of hosts. This will configure it as a nixosConfiguration and create an installer for it.

The `default.nix` file should look something like this:
```nix
{...}: {
  ...

  configurations = {
    skein = {
	  info = (import ./skein/info.nix) {};
      nixosModules = ./skein/os.nix;
      homeModules = ./skein/home.nix;
    };
    ...
    <add-host-here> = {
	  info = (import ./<host>/info.nix) {};
      nixosModules = ./<host>/os.nix;
      homeModules = ./<host>/home.nix;
    };
  };

  ...
}
```
