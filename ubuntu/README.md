# Ubuntu Hyprland
An Ubuntu-inspired Hyprland/Quickshell desktop setup, ported from Omarchy.

### Installation

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

### Prerequisites

`boot.sh` hard-aborts if any of these do not hold:

- x86_64 CPU
- ubuntu 26.04 lts
- btrfs as the root filesystem
- Secure Boot disabled
- no existing GNOME or KDE desktop installed
- not running as root

The target system is a minimal tty install created with debootstrap, using
Limine as the bootloader and btrfs subvolumes for `/`, `/home`, `/var/log` and
`/var/cache`. See the top-level README for the full target spec.
