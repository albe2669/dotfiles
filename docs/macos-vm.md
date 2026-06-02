# Testing Darwin Configurations

Since nix-darwin configurations target macOS, you need a macOS environment to fully build and test them. Here are several options:

## Option 1: QEMU/KVM with OSX-KVM (Linux host)

Use [OSX-KVM](https://github.com/kholia/OSX-KVM) to run macOS in a VM on Linux:

1. Clone the OSX-KVM repo and follow its setup instructions
2. Create a macOS VM (Sonoma or later recommended)
3. Inside the VM, install Nix:
   ```sh
   sh <(curl -L https://nixos.org/nix/install)
   ```
4. Install git:
    ```sh
    nix-shell -p git
    ```
5. Clone this dotfiles repo and test:
   ```sh
   sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake .#<host>
   ```

Note: Performance will be limited and Apple Silicon (`aarch64-darwin`) cannot be emulated on x86 hardware.

