{
  host,
  disko,
  nixpkgs,
  nixos-generators,
  lib,
  system,
  dotfilesLocation,
}: let
  defaultModule = {...}: {
    imports = [
      disko.nixosModules.disko
      ./base-iso.nix
    ];
  };

  isoDotfilesLocation = "/boot/dotfiles";
in
  nixos-generators.nixosGenerate {
    system = system;
    modules = [
      defaultModule
      ({
        config,
        lib,
        pkgs,
        ...
      }: let
        disko = pkgs.writeShellScriptBin "disko" ''${config.system.build.diskoScript}'';
        disko-mount = pkgs.writeShellScriptBin "disko-mount" "${config.system.build.mountScript}";
        disko-format = pkgs.writeShellScriptBin "disko-format" "${config.system.build.formatScript}";

        # This is a bit of a hack, but it works
        mntDotfilesLocation = "/mnt${dotfilesLocation}";
        actualIsoDotfilesLocation = "/iso${isoDotfilesLocation}";

        install-system = pkgs.writeShellScriptBin "install-system" ''
               set -euo pipefail

               echo "Formatting disks"
               . ${disko-format}/bin/disko-format

               echo "Mounting disks"
               . ${disko-mount}/bin/disko-mount

               echo "Installing system"
               nixos-install --root /mnt --flake ${actualIsoDotfilesLocation}#${host} -j 4

               echo "Copying dotfiles"
               mkdir -p ${mntDotfilesLocation}
               cp -r ${actualIsoDotfilesLocation}/* ${mntDotfilesLocation}

          echo "Executing home-manager"
          echo "This might fail, but it's fine"
          echo "If it does, just run it manually after booting into the system"

          nixos-enter --root /mnt -c "cd ${dotfilesLocation}; nixos-rebuild switch --flake .#${host}"

               echo "Done"
        '';
      in {
        # TODO: Remove this from here and make it an argument to the script instead
        imports = [
          ../../hosts/${host}/disko.nix
        ];

        disko.enableConfig = lib.mkDefault false;

        environment.systemPackages = [
          disko
          disko-mount
          disko-format
          install-system
        ];
      })
    ];

    customFormats = {
      install-iso-goose = {
        imports = [
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];

        isoImage = {
          squashfsCompression = "zstd -Xcompression-level 3";
          contents = [
            {
              source = ../..;
              target = isoDotfilesLocation;
            }
          ];
        };

        # override installation-cd-base and enable wpa and sshd start at boot
        systemd.services.wpa_supplicant.wantedBy = lib.mkForce ["multi-user.target"];

        formatAttr = "isoImage";
        fileExtension = ".iso";
      };
    };

    format = "install-iso-goose";
  }
