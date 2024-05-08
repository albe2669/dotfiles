# Install

> [!CAUTION]
> I wrote this guide entirely from memory. It will be updated at some point when i have to redo the install. Feel free to contact me if something seems wrong or if you need support

## ISO
To install first get your hands on an ISO file that contains the right host.

You can get the ISO by running this command:
```bash
make installer host=<your desired host>
```

Flash that ISO onto a USB stick and boot from it. I usually use `dd` for this task:
```
sudo dd if=./result/iso/<iso-name>.iso of=<usb-path> bs=4M status=progress conv=fdatasync oflag=sync
```

## Installing

When in the install run
```bash
sudo install-system
```

This might fail to setup the disks, if it does, you can manually do what `disko-format` using `gdisk`. The following step by step is for skeins disko config.

```bash
sudo gdisk /dev/sda
> d # repeat until there is no more partitions
> w
sudo gdisk /dev/sda
# Boot partition
> n
> # accept the default partition number
> # accept the default first sector
> +1M
> EF02
> c # change name
> 1 # partition number
> disk-main-boot # can be seen as the hierachy in disko.nix { disk = { main = { partitions = { boot }}}}
# ESP partition
> n
> # accept the default partition number
> # accept the default first sector
> +512M
> EF00
> c # change name
> 2 # partition number
> disk-main-ESP
# root partition
> n
> # accept the default partition number
> # accept the default first sector
> # accept the default last sector
> 8300 # or the default
> c # change name
> 2 # partition number
> disk-main-root
# verify
> p
```

On a 1TB disk the output of `> p` looks like:
```
Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048            4095   1024.0 KiB  EF02  disk-main-boot
   2            4096         1052671   512.0 MiB   EF00  disk-main-ESP
   3         1052672      2000408575   953.4 GiB   8300  disk-main-root
```

Now format the partitions with:
```bash
mkfs.vfat /dev/sda2
mkfs.ext4 /dev/sda3
```

From here on out you should follow the output of `cat $(which install-system)` right after `disko-format`. So start with `disko-mount`. If the formatting has succeeded the partitions should mount without issue.


