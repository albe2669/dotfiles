{
  host,
  disko,
  nixos-generators,
  modulesPath,
  lib,
  system,
}: let 
  defaultModule = {...}: {
    imports = [
      disko.nixosModules.disko
      ./base-iso.nix
    ];
  };
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

        install-system = pkgs.writeShellScriptBin "install-system" ''
          set -euo pipefail

          echo "Formatting disks"
          . ${disko-format}/bin/disko-format

          echo "Mounting disks"
          . ${disko-mount}/bin/disko-mount

          echo "Installing system"
          # nixos-install --system ${system}

          echo "Done"
        '';

      in {
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
           "${toString modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"
         ];

         isoImage = {
           squashfsCompression = "zstd -Xcompression-level 3"; 
           contents = [
            {
              source = ../..;
              destination = "/boot/dotfiles";
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
