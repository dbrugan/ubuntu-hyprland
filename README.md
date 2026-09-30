# Omarchy to Ubuntu

this project aims to write a custom ubuntu setup using hyprland and quickshell, using as a base Omarchy (version 3.8.4)

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