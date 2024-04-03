# Install
To install first get your hands on an iso file that contains the right host.

Flash that ISO onto a USB stick and boot from it.

When in the install run
```
sudo install-system
```

When that completes you can reboot and should run the following commands:
```
sudo nix-channel --update
sudo nixos-rebuild switch

nvim -c 'PlugInstall'
```
