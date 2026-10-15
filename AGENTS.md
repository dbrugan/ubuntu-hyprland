# Project Overview

This repo is a custom Ubuntu setup using Hyprland and Quickshell, based on
Omarchy 3.8.4. It is **not** a 1:1 Omarchy port, not a full-fledged distro, and
not an ISO: it is a manually installed (debootstrap + Limine + btrfs) Ubuntu LTS
with a Hyprland/Quickshell desktop.

- Follow Omarchy's conventions and setup as much as possible (snapper snapshots,
  limine bootloader, quickshell bar/shell), except where a deviation is recorded
  below.
- Use pacstall (custom pacscripts) for packages not available in Ubuntu repos.
- Install entry point is `./boot.sh` in the repo; see `ubuntu/README.md`.

# Supported Releases

Support targets Ubuntu 26.04 only, the release this setup is developed and
tested against. Other LTS releases, non-LTS releases, and anything past
standard security maintenance are out of scope.

- `supported_lts` in `ubuntu/install/preflight/guard.sh` is the single source of
  truth and the preflight guard enforces it. Do not widen the list casually: it
  requires re-running the package audit against each added release, since
  package names are not stable across Ubuntu releases.
- 22.04 is Canonical-supported until May 2027 but is excluded on purpose: the
  Hyprland it ships is too outdated to run this setup, even with a PPA
  backport.
- Anything added to `install/ubuntu-base.packages` must exist in the 26.04
  archive, or be pacstalled.

# Repo Layout

- `omarchy/` - the upstream Omarchy reference, pinned to the `v3.8.4` release
  tag (detached HEAD at `8fcc9d60`). Read-only: never edit this directory.
  Consult it for conventions and patterns to port. Upstream's default branch
  tracks a moving alpha, so re-pin with `git -C omarchy checkout v3.8.4`
  rather than tracking master. Note its `version` file reads `3.8.3`: that is
  an upstream tagging quirk, not a different release.
- `ubuntu/` - the actual work: installer, bin commands, configs.
- `README.md` - project goals and target-system spec (btrfs subvolumes, zram,
  no swap, network-manager default, minimum tty install).

# Task Guides

Deeper instructions live in the Omarchy reference. Read the matching guide there
before porting or extending that area:

- `omarchy/default/omarchy-skill/SKILL.md` - Omarchy's own conventions,
  including the privilege-escalation guidance referenced below
- `omarchy/AGENTS.md` - upstream's guidance for working in the reference
- `omarchy/install/` and `omarchy/bin/` - the source being ported; read these
  directly for conventions rather than looking for a per-topic guide

`v3.8.4` ships a single consolidated skill at `default/omarchy-skill/SKILL.md`.
The per-topic guides (`command-metadata.md`, `install-scripts.md`,
`shell-dev.md`, `icon-font.md`, `acceptance-tests.md`,
`visual-verification.md`) exist only from `v4.0.0` onward, under
`agents/skills/`. This port follows its own conventions in this file instead;
do not add task-guide references to files absent from the pinned tag.

# Style

- Two spaces for indentation, no tabs
- Use bash 5 conditionals: use `[[ ]]` for string/file tests and `(( ))` for numeric tests
- In `[[ ]]`, don't quote variables, but do quote string literals when comparing values (e.g., `[[ $branch == "dev" ]]`)
- Prefer `(( ))` over numeric operators inside `[[ ]]` (e.g., `(( count < 50 ))`, not `[[ $count -lt 50 ]]`)
- For strings/paths with spaces, quote them instead of escaping spaces with `\ ` (e.g., `"$APP_DIR/Disk Usage.desktop"`, not `$APP_DIR/Disk\ Usage.desktop`)
- Shebangs must use `#!/bin/bash` consistently (never `#!/usr/bin/env bash`)
- Scripts under `install/` may be sourced and intentionally omit shebangs

# Command Naming

All commands start with `ub-`. Prefixes indicate purpose:

- `cmd-` - check if commands exist, misc utility commands
- `capture-` - screenshots, screen recordings, and other capture tools
- `pkg-` - package management helpers
- `hw-` - hardware detection (return exit codes for use in conditionals)
- `refresh-` - copy default config to user's `~/.config/`
- `restart-` - restart a component
- `launch-` - open applications
- `install-` - install optional software
- `setup-` - interactive setup wizards
- `toggle-` - toggle features on/off
- `theme-` - theme management
- `update-` - update components

Current `bin/` files (e.g. `ub-npx-install`, `ub-tui-install`) use a verb-last
form. New commands should follow the verb-first prefix scheme above unless the
command is one of the established helpers listed below.

# Command Metadata

Commands in `bin/` declare CLI metadata in comments near the top of the file.
The router (in Omarchy, `bin/omarchy`; to be ported as the `ub` dispatcher)
scans the first 80 lines for `# ub:key=value` metadata:

- `# ub:group=...` - override the command group inferred from the filename
- `# ub:name=...` - override the command name inferred from the filename
- `# ub:summary=...` - short help text (required for user-facing commands)
- `# ub:args=...` - usage arguments
- `# ub:examples=...` - examples separated with ` | `
- `# ub:alias=...` / `# ub:aliases=...` - alternate routes
- `# ub:hidden=true` - hide from default command listings
- `# ub:requires-sudo=true` - mark commands that require sudo (`hidden` and
  `requires-sudo` must be `true` or omitted)

The authoritative list of user-facing command groups lives in
`GROUP_DESCRIPTIONS` in `bin/omarchy`. Keep it updated when adding a new command
prefix users are meant to browse to, and consult it rather than maintaining a
second exhaustive prefix list.

Example:

```bash
# ub:summary=Take a screenshot
# ub:args=[smart|region|windows|fullscreen] [slurp|copy]
# ub:examples=ub screenshot | ub capture screenshot region
```

# Runtime Environment

- `$UBUNTU_PATH` (default `~/.local/share/ubuntu-hyprland`), `$UBUNTU_INSTALL`,
  and `$UBUNTU_INSTALL_LOG_FILE` are exported by `install.sh`.
- Use `$UBUNTU_PATH` / `$UBUNTU_INSTALL` instead of hardcoded
  `~/.local/share/ubuntu-hyprland` paths. Several install scripts still hardcode
  it; prefer the env vars in new code.
- `install.sh` prepends `$UBUNTU_PATH/bin` to `PATH`; bin commands are invoked as
  `ub-*`.

# Helper Commands

Use these instead of raw shell commands:

- `ub-cmd-missing` / `ub-cmd-present` - check for commands
- `ub-pkg-missing` / `ub-pkg-present` - check for packages (checks both apt and
  pacstall)
- `ub-pkg-add` - install packages via apt
- `ub-pkg-pacstall-add` - install pacscripts via pacstall
- `ub-notification-send` - send desktop notifications; do not call `notify-send` directly

Commands installed by the default package set are runtime invariants. Invoke
them directly; do not add defensive `ub-cmd-present` / `ub-cmd-missing` checks
around them. Use command-presence helpers only for genuinely optional
dependencies or code that can run before the default package set is installed.

Exceptions are allowed for package-helper scripts where the helper
may not be available yet, where the helper itself is being implemented, or where
direct package-manager behavior is required.

# Packaging

- `install/ubuntu-base.packages` - one package per line, `#` comments and blank
  lines ignored. This is the singular package list; split into base vs "other"
  lists once the port grows.
- Prefer `ub-pkg-add` for installing; it currently installs via apt and is
  expected to also route pacstall packages.
- Write custom pacscripts for packages unavailable in Ubuntu repos.
- TUI/npx installers (`ub-tui-install`, `ub-npx-install`) write `.desktop` files
  and wrappers under `~/.local/`; keep their interactive vs
  positional-argument behavior consistent.

# Browsers

Firefox is installed from Mozilla's apt repository, not from Ubuntu's archive.
Ubuntu ships `firefox` as a snap-transition package (`1:1snap1`), so a plain
`apt install firefox` yields the snap.

- `install/preflight/mozilla.sh` adds `packages.mozilla.org`, following Mozilla's
  own instructions: keyring import, signing-key fingerprint check, a deb822
  `.sources` file, an apt pin, then `apt update`.
- That pin is load-bearing, not decoration. Ubuntu's transitional package
  carries epoch 1, which outranks Mozilla's unversioned build on raw version
  comparison, so without a pin apt selects the snap wrapper.
- Adding the repository is a preflight concern; adding the package itself is a
  base-list concern (`install/ubuntu-base.packages`). Keep them separate.

# Privileged Commands

- Draw the `sudo` line by whether the caller has a terminal to enter a password
  in; follow the Omarchy "Privilege Escalation" guidance
  (`omarchy/default/omarchy-skill/SKILL.md`).
- The installer writes a limited passwordless-sudo allowlist to
  `/etc/sudoers.d/first-run` (see `install/preflight/first-run-mode.sh`). Do not
  broaden it beyond the listed commands.

# Migrations

Migrations are a deliberate deviation from Omarchy: they are not ported, and
`omarchy-migrate` / `ub-dev-add-migration` will not exist here. Do not add a
migration runner or `migrations/` directory. For state repair, use idempotent
`apply-*`/`setup-*` commands or fold the repair into the `ub-update` path
instead.

# Config Structure

- `config/` - default configs copied to `~/.config/`
- `default/themed/*.tpl` - templates with `{{ variable }}` placeholders for theme colors
- `themes/*/colors.toml` - theme color definitions using semantic names:
  `mode`, `accent`, `selection`, `muted`, the `background`/`foreground`
  families (`dark_*`, `light_*`, `bright_*`), and named colors
  (`red`/`green`/`yellow`/`blue`/`magenta`/`cyan`/`orange`/`brown` plus
  `bright_*` variants). The old `color0-15` palette is legacy.

# Theming

Omarchy's theming is a deliberate deviation and is not ported wholesale. Do not
port `omarchy/install/config/theme.sh` verbatim, upstream's `themes/`
directory, or the template-rendering and per-appsetter machinery
(`omarchy-theme-set-templates`, `omarchy-theme-set-{foot,gnome,browser,vscode,obsidian,keyboard}`,
the `color0-15` palette and theme-selection machinery do not apply).

- Upstream's `theme.sh` carries Chromium-specific setup: it creates
  `/etc/chromium/policies/managed` and clears `~/.config/chromium/SingletonLock`.
  Porting it verbatim would drag in a browser this project does not use.
- Any theming this project does have is our own, described under
  `# Config Structure`: `themes/*/colors.toml` with semantic color names, and
  `default/themed/*.tpl` templates.
- The minimal local commands that the Elephant menus and Hypr configs depend
  on are in scope: `ub-theme-set` (atomic `~/.config/ubuntu/current` swap only),
  `ub-theme-bg-set`, and the `ub-plymouth-*` trio. Keep them free of template
  rendering and per-app setters; theme content seeding is separate work.

# Refresh Pattern

To copy a default config to user config with automatic backup:

```bash
ub-refresh-config hypr/hyprlock.conf
```

This copies the default config to `~/.config/hypr/hyprlock.conf`. The argument
is interpolated into both paths and only checked with `[[ -e ]]`, so pass a
plain relative path: a name containing `..` resolves and copies, landing outside
`~/.config` rather than being rejected.

# Tests

Automated tests are not ported yet. The Omarchy model to follow:

- `./test/all` - aggregate runner for CLI and shell tests (no graphical tests)
- `./test/cli` - CLI routing, command metadata, theme helpers, and safe dispatch
  coverage, using TAP-style `pass`/`fail` output and `timeout` on help dispatch
- `./test/shell` - runs every `test/shell.d/*-test.sh`; source
  `test/shell.d/base-test.sh` for shared assertions
- Tests enforce that `bin/` never uses raw `command -v` or bare `notify-send`
  (helpers must be used)

# Git

- Commit messages follow the Conventional Commits specification (conventionalcommits.org) which is structured as follows:

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

- before <type> there should be an emoji following gitmoji convention (gitmoji.dev); prefix each
  commit with a relevant emoji (e.g. `✨`, `♻️`, `🐛`, `🔧`).
- Commits must be atomic: a single, self-contained change that performs one and
  only one logical unit of work. Each commit fixes one bug, adds one feature,
  or refactors one specific piece of code — never a mix of unrelated work.
- Every atomic commit must leave the tree in a complete, working state: the
  change is finished (no half-written code carried forward) and `./test/all`
  passes at that commit.
- Keep commits independently reversible: a commit should revert, cherry-pick,
  and bisect cleanly without dragging unrelated changes along. If reverting
  your commit would break something it didn't intend to touch, it wasn't atomic.
- Commit messages should be succinct and describe the change being made.

# Known WIP Gaps

These pieces are intentional scaffolding, not breakage:

- `install/login/` is ported: plymouth, default-keyring, limine-snapper, and
  sddm run from `all.sh`. Upstream's `hibernation.sh` is deliberately not
  ported; see the bullets below.
- `config/` holds the ported Hyprland tree (`config/hypr/`), the Waybar
  config (`config/waybar/`), the uwsm session env (`config/uwsm/`), a fontconfig
  default for `ub-font-set`, hook samples under `config/ubuntu/hooks/`, and
  defaults for the apps the desktop actually launches or offers: `mako`,
  `fcitx5` plus its `environment.d` variables, `swayosd` plus its user service,
  `walker` with the elephant provider configs, `foot`/`ghostty`/`kitty`,
  `alacritty`, `starship`, `tmux`, `btop`-adjacent TUIs (`lazygit` ships no
  config upstream), `fastfetch`, `git`, `wiremix`, `opencode`, Typora themes,
  and the share picker. `imv` and `xournalpp` are not installed, so their
  configs are absent.
- Per-app theme files are deliberately not rendered; see `# Theming`. Configs
  that upstream pulled their colors from a rendered per-app theme file ship
  with the colors spelled out instead, and say so in a header comment. The
  affected files are `config/{foot,ghostty,kitty}`, `config/swayosd/style.css`,
  and `config/hyprland-preview-share-picker/config.yaml`. Switching themes
  will not recolor them.
- `themes/` ships Tokyo Night and Catppuccin Latte. Each theme carries the
  files the desktop sources directly (`hyprland.conf`, `hyprlock.conf`,
  `waybar.css`, `walker.css`, `gum.env.conf`, `colors.toml`, `backgrounds/`),
  pre-rendered rather than templated, so `ub-theme-set` stays a directory
  swap. Keep exactly one `background` and one `foreground` line at the start
  of a key in `colors.toml`: `ub-plymouth-set-by-theme` greps those prefixes
  and passes every match to `ub-plymouth-set` as separate arguments.
- `install/first-run/` is ported and driven by `ub-first-run`. Upstream's
  `cleanup-reboot-sudoers.sh` is dropped because `allow-reboot.sh` is not
  ported and never writes that file, and `install-voxtype.hook` is dropped
  because voxtype is not ported. `firewall.sh` skips the Docker rules when
  `ufw-docker` is absent, since it is not in the Ubuntu archive.
- `bin/` carries the update and repair lifecycle: `ub-update` (snapshot, git,
  apt, pacstall, prune, post-update hook, restart prompts), `ub-reinstall`,
  `ub-snapshot`, `ub-version`, `ub-state`, and the `ub-refresh-*` family.
  Two things are deliberately absent. `ub-migrate`/`ub-dev-add-migration`
  never existed here; see `# Migrations`. `ub-upload-log` is not ported because
  it posts to omarchy.org, which is not this project's service.
- `ub-refresh-config` is the recovery path for `config.sh`'s copy. It backs up,
  replaces, prints the diff, and drops the backup when nothing changed. Do not
  replace it with a plain copy: that is the only way back from a re-run.
- The update pipeline has no AUR or migration step. `ub-update-pacstall` covers
  what `pacman -Syua` did upstream, and there is no migration runner.
- There are no release channels. Upstream's `branch-set`, `channel-set`,
  `version-branch`, and `version-channel` are not ported: this setup tracks a
  git branch plus apt, so `ub-update-available` compares local and remote HEAD
  rather than release tags, and `ub-version-pkgs` reports the last apt upgrade.
- Upstream's `update-keyring` is not ported. It maintains `archlinux-keyring`
  through `pacman-key`; Ubuntu's repository keys ship with `ubuntu-keyring` and
  are refreshed by the `apt update` that `ub-update-system-pkgs` already runs.
  `update-without-idle` is likewise absent because upstream reduced it to a
  no-op, and `ub-update-perform` manages idle itself.
- `setup-security-fido2` and `remove-security-fido2` are not ported. They edit
  `pam_u2f.so` into `/etc/pam.d/sudo` and `polkit-1`, but Ubuntu 26.04 ships no
  PAM module providing `pam_u2f.so` — only the `libfido2` libraries and
  `fido2-tools`. The fingerprint equivalent is ported, and Ubuntu splits it
  differently: `pam_fprintd.so` lives in `libpam-fprintd`, not `libfprint`.
- `ub-debug` deliberately has no upload option. Upstream posts the log to
  `logs.omarchy.org`, which is not this project's service.
- Theming is minimal by design; see `# Theming`. `config/all.sh` does
  not reference a `theme.sh`.
- `install/packaging/webapps.sh` and the `ub-launch-webapp` /
  `ub-launch-or-focus-webapp` helpers are not ported (webapps are
  intentionally omitted from this setup).
- `install/config/hardware/nvidia.sh` appends its NVIDIA environment block to
  `~/.config/uwsm/env` (sourced at login), following upstream's migration in
  commit `638e35fc` away from the never-sourced `config/hypr/envs.conf`.
- `install/config/config.sh` copies `config/` over `~/.config/` unconditionally,
  so re-running the installer discards hand edits to `~/.config/hypr/*.conf`.
  Upstream has the same line and answers it with `omarchy-refresh-config`,
  which is not ported.
- `install/config/config.sh` copies `config/` over `~/.config/` unconditionally,
  so re-running the installer discards hand edits to `~/.config/hypr/*.conf`.
  Answer it with `ub-refresh-config`, which is ported and backs up first.
- The login stage does not set up hibernation. Upstream's `hibernation.sh` is
  not ported: it calls `omarchy-hibernation-setup`, and hibernation is
  intentionally omitted to match the target spec (no swap, zram enabled).
- `login/limine-snapper.sh` is ported, but rewritten for Ubuntu rather than
  copied. It owns `/boot/limine.conf`, the UKIs, and the snapper snapshot menu;
  the bootloader itself is still deployed by hand (see `ubuntu/README.md`) and
  this script converges an existing install rather than creating one. Upstream's
  Arch plumbing is replaced one-for-one: `mkinitcpio` conf.d -> `initramfs-tools`
  conf.d plus an explicit module list, `limine-mkinitcpio-hook` -> `ukify` driven
  from `/etc/kernel/postinst.d` and `/etc/initramfs/post-update.d`,
  `limine-install` -> copying `BOOTX64.EFI` and registering it with `efibootmgr`,
  and the `libalpm` re-enable step is dropped since dpkg kernel hooks always run.
  Two constraints are worth keeping in mind when editing it. First, exactly two
  things write `/boot/limine.conf`: this script's kernel entries and
  `limine-snapper-sync`'s snapshot entries. Do not add `limine-entry-tool`
  without first disabling its `/etc/boot/hooks` automation, or it becomes a
  third writer. Second, UKIs are built unsigned, which is sound only because
  `install/preflight/guard.sh` hard-aborts on Secure Boot being enabled.
- `install/default/snapper/root` is installed by `login/limine-snapper.sh`.
- Several upstream `install/config/` scripts are dropped as Arch-only, rather
  than ported and left inert. `increase-lockout-limit.sh` rewrites
  `pam_faillock` lines in `/etc/pam.d/system-auth`, but Ubuntu ships
  `pam_faillock` unused with `/etc/security/faillock.conf` entirely commented
  out, so the edit would do nothing. `kernel-modules-hook.sh` enables
  `linux-modules-cleanup.service`, a unit systemd does not ship on Ubuntu.
  `fix-powerprofilesctl-shebang.sh` corrects an `env python3` shebang, and
  Ubuntu's `powerprofilesctl` already ships an absolute `#!/usr/bin/python3`.
  `sudoless-asdcontrol.sh` is Apple-display brightness, covered by the vendor
  hardware gap below. `omarchy-ai-skill.sh` and `pi.sh` install Omarchy's own
  skill and pi-agent extension, neither of which this port carries.
- Of upstream's eight generic hardware fixes, three are ported: `network.sh`
  (enables iwd and masks `systemd-networkd-wait-online`), `fix-fkeys.sh`, and
  `fix-synaptic-touchpad.sh`. The rest need packages absent from the archive
  (`broadcom-wl`, `yt6801-dkms`, `tuxedo-drivers-nocompatcheck-dkms`) or
  mkinitcpio configuration. `set-wireless-regdom.sh` is dropped rather than
  translated: it targets CRDA's `/etc/conf.d/wireless-regdom`, and Ubuntu has
  dropped CRDA without a documented equivalent config path for iwd.
- DNS policy is `ub-dns`, ported from upstream v4.0.0's DNS command rather than
  the v3.8.4 `setup-dns` it replaced there. It configures three layers because
  NetworkManager is the network manager here: a `conf.d` global DNS entry,
  per-connection `ipv4/ipv6.ignore-auto-dns`, and `systemd-resolved.conf`.
  Writing only `resolved.conf`, as the 3.8.4 version did, would be silently
  overridden by NM's per-connection settings. `install/first-run/dns-resolver.sh`
  is separate and still needed: it only ensures `/etc/resolv.conf` points at the
  resolved stub, which is plumbing rather than provider policy.
- The hardware-specific packaging scripts (`asus-rog.sh`, `framework16.sh`,
  `surface.sh`, `dell-xps-touchpad-haptics.sh`) are not ported; every package
  they install (`asusctl`, `qmk-hid`, `linux-firmware-marvell`,
  `dell-xps-touchpad-haptics`, …) is absent from Ubuntu 26.04.
- The vendor `install/config/hardware/` trees (`intel/`, `asus/`,
  `framework/`, `apple/`, `lenovo/`) are not ported either: the package-backed
  fixes have nothing to install, and the package-free ones were triaged out
  with them rather than carried without their detectors.
- The vendor `ub-hw-*` detection helpers (`hw-intel*`, `hw-asus-*`,
  `hw-framework16`, `hw-surface`, `hw-dell-xps-*`, `hw-hybrid-gpu`, `hw-vulkan`)
  are deliberately omitted as well. Each exists upstream only to gate one of
  the scripts above, and carrying detectors for hardware this setup does not
  support would invite wiring them into menus and install stages that can never
  fire. The generic `ub-hw-match` (DMI string match) stays and covers the
  model-gated fixes that are ported.
