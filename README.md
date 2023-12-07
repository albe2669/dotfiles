# My .dotfiles and NixOS configuration

## What is this?
This is my personal config files for NixOS and pretty much every program i use. It's not really designed for others to use, since it's very personalised, but you should feel absolutely free to try it. I will be adding a guide for adapting to more machines and usecases when i finish it.

## Overviews
### File structure
```
.
├── home
├── hosts
│  └── <host>
│     ├── hardware-configuration.nix
│     ├── home.nix
│     └── os.nix
├── modules
│  ├── configs
│  ├── services
│  ├── core-desktop.nix
│  └── core-server.nix
├── lib
├── Makefile
└── flake.nix
```

#### `flake.nix`
The entrypoint and where it all begins. This file configures which architectures to build for, building arguments and is where each buildable host is specified.

`flake.nix` is also where every input configuration option should be specified.

#### `Makefile`
This is where the magic happens. This file is responsible for building, running, testing and installing the configuration. 

#### `hosts`
Referenced by `flake.nix`, this directory contains a directory for each host. Eachost should specify a `hardware-configuration.nix` which is specific to that host. These can either be generated or found [here](https://github.com/NixOS/nixos-hardware).

Secondly each host specifies a `os.nix` file which imports the hardware configuration, which type of host it is from `modules` and other OS related configurations.

Lastly each host has a `home.nix` file which imports modules from `home` and specifies everything that should be configurad and installed on the user level.

#### `modules`
This directory contains all the modules that are used to configure the system. These are split into two categories, `configs` and `services`.

`configs` are modules that configure a specific program or part of the system. These are usually imported by `core-<type-of-machine>.nix`.

`services` are modules that configure a service that should be running on the system. These are usually imported by `core-<type-of-machine>.nix`.

#### `home`
This directory contains all the programs and modules that are used to configure the user level. These are primarily programs. If a program has additional, non Nix, configuration files, then the program is placed in it's own directory with those files in a `config` directory and a `default.nix` file to import it with.

#### `lib`
This directory contains functions, utilities and other things used to help build this flake.

## TODOs
All TODOs, known issues, etc, are tracked in the [issues](https://github.com/albe2669/dotfiles)

## Building, running, testing, installing
### Testing
While this repo is set up to be as modular as possible, one of the hosts `skein` is designed to be the test of what happens if everything is enabled. This also makes it perfect for testing if these configurations make sense to you. 

To test it out ensure you have QEMU installed. Then run

```bash
make vm
./result
```

A QEMU VM will be started with everything enabled.
