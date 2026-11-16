# Omarchy to Ubuntu

this project aims to write a custom ubuntu setup using hyprland and quickshell, using as a base Omarchy (version 4.0.4)

## What this project aims to

- develop a custom ubuntu setup using hyprland window manager
- follow omarchy's conventions and setup as much as possible (snapper as btrfs snapshots tool, limine as bootloader, quickshell for bar and shell setups, etc.)

## What this project doesn't aim

- do a 1:1 omarchy port to ubuntu
- be a full fledged linux distro (what we want is just a custom hyprland setup)
- build an iso for live booting and install

## What needs to be done

- analyze the omarchy project at ./omarchy
- adapt omarchy setup, configs, tools, etc. for every ubuntu lts that canonical currently supports
- validate the package list against each supported lts, not just the newest one (currently done for 26.04 only)
- write the configuration made for ubuntu at ./ubuntu
- use pacstall for packages that aren't available in ubuntu repos, writting custom pacscripts for them

## Supported releases

support is targeted at ubuntu 26.04 lts (resolute) only, the release this setup is developed and tested against. The installer's preflight guard enforces this, so any other release exits with an error. Widening support is a deliberate decision: it means re-running the package audit against each added release, since package names are not stable across ubuntu releases.

out of scope:

- 24.04 lts (noble) and 22.04 lts (jammy) - not targeted for now; 22.04's hyprland is also too outdated to run this setup even with a ppa backport
- 20.04 lts - left standard maintenance in may 2025
- non-lts releases

## Target system

while the system we aim to is ubuntu, it isn't the regular ubuntu installed with ubiquity installer, rather than that is a custom ubuntu installed manually with debootstrap which will use this structure:

- a supported ubuntu lts release (see supported releases above)
- limine bootloader
- btrfs filesystem with subvolumes:
  - @ mounted at /
  - @home mounted at /home
  - @log mounted at /var/log
  - @cache mounted at /var/cache
- minimum tty install
- network-manager enabled as default for all networks
- no swap partition, no swapfile, zram enabled

## Prerequisites

`boot.sh` hard-aborts if any of these do not hold:

- x86_64 CPU
- Ubuntu 26.04 LTS
- btrfs as the root filesystem
- Secure Boot disabled
- no existing GNOME or KDE desktop installed
- not running as root

The target system is a minimal tty install created with debootstrap, using
Limine as the bootloader and btrfs subvolumes for `/`, `/home`, `/var/log` and
`/var/cache` (see the target system section above for the full spec).

## Preparing the system

The installer configures an existing Ubuntu install. It does not create one,
and it does not deploy the bootloader. Do this first.

**1. Install Ubuntu 26.04 with debootstrap.** Create the btrfs layout:

```
/dev/.../          gpt
  1                512M   EFI system partition, mounted at /boot
  2                1G     Linux filesystem        @       -> /
  3                ...    Linux filesystem        @home   -> /home
  4                ...    Linux filesystem        @log    -> /var/log
  5                ...    Linux filesystem        @cache  -> /var/cache
```

Mount `/boot` as the ESP. Install a minimal tty system with a kernel, then
confirm NetworkManager is enabled and that there is no swap.

**2. Deploy Limine.** The installer converges an existing Limine setup, so
deploy the bootloader before running it. Install the `limine` package (via
pacstall, from the repo configured in `install/preflight/pacstall.sh`) and
install it to the ESP:

```
sudo limine bios-install /dev/nvme0n1              # legacy BIOS
# or, for UEFI, copy the payload and register it:
sudo cp /usr/share/limine/BOOTX64.EFI /boot/EFI/BOOT/
sudo efibootmgr --create --disk /dev/nvme0n1 --part 1 \
  --label "Limine" --loader '\EFI\BOOT\BOOTX64.EFI' --unicode
```

Then place a **minimal** `limine.conf` at `/boot/limine.conf` containing at
least a single boot entry with a correct kernel command line. The installer
reads the `cmdline:` line from it to build the UKIs and the snapshot menu
entries, then rewrites the file from its own template. Getting that one
`cmdline` right is the only part of this step that matters:

```
/Ubuntu
protocol: linux
path: boot():/vmlinuz-<version>
cmdline: root=UUID=<root-uuid> rootflags=subvol=@ rw rootfstype=btrfs <your-other-args>
```

`install/login/limine-snapper.sh` exits with an error if no `limine.conf` is
found, so this file must exist before you run `boot.sh`.

## Installation

Clone the repo to the path the installer expects:

```
git clone <repo-url> ~/.local/share/ubuntu-hyprland
```

Then run the installer from inside that clone:

```
cd ~/.local/share/ubuntu-hyprland
./boot.sh
```

The installer resolves its own install tree from `~/.local/share/ubuntu-hyprland`,
so it must be cloned there rather than somewhere else. Running it from a
different location exits with an error telling you the expected path.

Run `boot.sh` rather than `install.sh`: only `boot.sh` sets
`UBUNTU_ONLINE_INSTALL`, without which the apt, pacstall, Mozilla, and Docker
repository setup is silently skipped.

## After the first reboot

The installer writes a first-run marker. On the first login it applies the
post-install steps that need a session: power profile and battery timer,
firewall, resolved symlink, GTK theme, and the welcome
notifications. Watch for a "Setup Wi-Fi" notification if the machine has no
network yet.

## Changing things later

`install/config/config.sh` copies `config/` over `~/.config/` unconditionally,
so re-running `boot.sh` discards hand edits to `~/.config`. Use the refresh
commands to pull a file back to its shipped default; each one backs up the
current file and prints a diff first:

```
ub refresh config hypr/hypridle.conf
ub refresh config hypr/hyprland.lua
ub refresh hyprland
ub refresh shell
```

The Hyprland tree is Hyprland Lua, matching the upstream reference pinned at
Omarchy v4.0.4. `~/.config/hypr/hyprland.lua` is the entry point: it loads the
shared defaults from `$UBUNTU_PATH/default/hypr/` and the user overrides
(`monitors.lua`, `input.lua`, `bindings.lua`, `looknfeel.lua`,
`autostart.lua`) from `~/.config/hypr/`. Persistent toggles live as Lua flags
under `~/.local/state/ubuntu/toggles/hypr/`. The bar, menus, notifications,
OSD, wallpaper, lock, and polkit agent all come from the Quickshell shell.