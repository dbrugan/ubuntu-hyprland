# Project Overview

This repo is a custom Ubuntu setup using Hyprland and Quickshell, based on
Omarchy. The port was built against 3.8.4 and now tracks `v4.0.4`. It is
**not** a 1:1 Omarchy port, not a full-fledged distro, and
not an ISO: it is a manually installed (debootstrap + Limine + btrfs) Ubuntu LTS
with a Hyprland/Quickshell desktop.

- Follow Omarchy's conventions and setup as much as possible (snapper snapshots,
  limine bootloader, quickshell bar/shell), except where a deviation is recorded
  below.
- Use pacstall (custom pacscripts) for packages not available in Ubuntu repos.
- Install entry point is `./boot.sh` in the repo; see `README.md`.

# Supported Releases

Support targets Ubuntu 26.04 only, the release this setup is developed and
tested against. Other LTS releases, non-LTS releases, and anything past
standard security maintenance are out of scope.

- `supported_lts` in `install/preflight/guard.sh` is the single source of
  truth and the preflight guard enforces it. Do not widen the list casually: it
  requires re-running the package audit against each added release, since
  package names are not stable across Ubuntu releases.
- 22.04 is Canonical-supported until May 2027 but is excluded on purpose: the
  Hyprland it ships is too outdated to run this setup, even with a PPA
  backport.
- Anything added to `install/ubuntu-base.packages` must exist in the 26.04
  archive, or be pacstalled.

# Repo Layout

- `omarchy/` - the upstream Omarchy reference, pinned to the `v4.0.4` release
  tag (detached HEAD at `c668141e`). Read-only: never edit this directory.
  Consult it for conventions and patterns to port. Upstream's default branch
  tracks a moving alpha, so re-pin with `git -C omarchy checkout v4.0.4`
  rather than tracking master. Note its `version` file reads `4.0.0.alpha`:
  that is an upstream tagging quirk, not a different release.
- The repo root is the actual work (moved up from the old `ubuntu/`
  subdirectory): `boot.sh`, `install.sh`, `bin/`, `install/`, `config/`,
  `default/`, `shell/`, `themes/`, and the app data files. All `ubuntu/`
  path references in older notes resolve to the repo root now.
- `README.md` - project goals and target-system spec (btrfs subvolumes, zram,
  no swap, network-manager default, minimum tty install).

# Task Guides

Deeper instructions live in the Omarchy reference. Read the matching guide there
before porting or extending that area:

- `omarchy/default/agents/skills/omarchy/SKILL.md` - Omarchy's own conventions,
  including the privilege-escalation guidance referenced below
- `omarchy/AGENTS.md` - upstream's guidance for working in the reference
- `omarchy/agents/skills/` - per-topic contributor guides; read the matching one
  before touching that area:
  `command-metadata.md`, `install-scripts.md`, `shell-dev.md`, `icon-font.md`,
  `acceptance-tests.md`, `visual-verification.md`
- `omarchy/docs/` - upstream design notes worth reading before porting a
  subsystem: `file-layout.md` (repo-to-filesystem mapping and the
  seed/finalize/resync model), `theming.md`, `migrations.md`, `update-process.md`
- `omarchy/install/` and `omarchy/bin/` - the source being ported; read these
  directly for conventions rather than looking for a per-topic guide

Up to `v3.8.4` these per-topic guides did not exist: that tag ships a single
consolidated skill at `default/omarchy-skill/SKILL.md`, and `agents/skills/`
only appears from `v4.0.0` onward. The pinned tag is `v4.0.4`, so the guides
exist and are expected. This port still keeps its own conventions in this file
where they diverge; the guides are the reference for upstream's patterns, not a
mandate to adopt them.

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

This is a sample, not an exhaustive list: do not extend it here. The
authoritative list lives in `GROUP_DESCRIPTIONS` in the dispatcher, and upstream
`AGENTS.md` gives the same instruction for the same reason — a second exhaustive
prefix list drifts. Note the upstream prefix set also shifts between releases
(`npx` and `ac` were dropped in v4.0.0), so copying it wholesale is wrong too.

Current `bin/` files (e.g. `ub-npx-install`, `ub-tui-install`) use a verb-last
form. New commands should follow the verb-first prefix scheme above unless the
command is one of the established helpers listed below.

# Command Metadata

Commands in `bin/` declare CLI metadata in comments near the top of the file.
The dispatcher (`bin/ub`, upstream `omarchy/bin/omarchy`) scans the first
80 lines for `# ub:key=value` metadata. `ub:` is this port's rename of upstream's
`omarchy:` prefix; the supported key set is otherwise identical:

- `# ub:group=...` - override the command group inferred from the filename
- `# ub:name=...` - override the command name inferred from the filename
- `# ub:summary=...` - short help text (expected for user-facing commands)
- `# ub:args=...` - usage arguments
- `# ub:examples=...` - examples separated with ` | `
- `# ub:alias=...` / `# ub:aliases=...` - alternate routes
- `# ub:hidden=true` - hide from default command listings
- `# ub:requires-sudo=true` - mark commands that require sudo (`hidden` and
  `requires-sudo` must be `true` or omitted)

`hidden` and `requires-sudo` are the two keys the router rejects a `false` value
for; every other key is free-form. A missing summary is not fatal — the router
falls back to a generated one — but every user-facing command should carry one.

Keep `GROUP_DESCRIPTIONS` in the dispatcher updated when adding a new command
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
  and `$UBUNTU_INSTALL_LOG_FILE` are exported by `install.sh`. This is a
  local model with no upstream equivalent: v4.0.4 has deleted `install.sh` and
  `boot.sh` entirely, and instead ships `omarchy` and `omarchy-settings` as
  packages, with `OMARCHY_PATH` provided by the uwsm session environment rather
  than exported by an installer. See `omarchy/docs/file-layout.md` for the
  upstream mapping.
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
- `ub-pkg-drop` - remove packages
- `ub-pkg-pacstall-add` - install pacscripts via pacstall
- `ub-notification-send` - send desktop notifications; do not call `notify-send` directly

Commands installed by the default package set are runtime invariants. Invoke
them directly; do not add defensive `ub-cmd-present` / `ub-cmd-missing` checks
around them. Use command-presence helpers only for genuinely optional
dependencies or code that can run before the default package set is installed.

Exceptions are allowed for package-helper scripts where the helper
may not be available yet, where the helper itself is being implemented, or where
direct package-manager behavior is required. Upstream also exempts migrations
from the helper rules; this port has no migrations, so there is no such case.

# Packaging

- `install/ubuntu-base.packages` - one package per line, `#` comments and blank
  lines ignored. This is the singular package list, where upstream v4.0.4 has
  already split into `omarchy-base.packages` and `omarchy-other.packages` and
  dropped `install/packaging/` entirely. Keep the single list until the port
  actually grows; the split is about how much is installed by default, and ours
  is not there yet.
- Prefer `ub-pkg-add` for installing; it currently installs via apt and is
  expected to also route pacstall packages.
- Write custom pacscripts for packages unavailable in Ubuntu repos.
- The TUI installer (`ub-tui-install`) writes `.desktop` files and wrappers
  under `~/.local/`; keep its interactive vs positional-argument behavior
  consistent. `ub-npx-install` is a port-only holdover: upstream dropped the
  `npx` group in v4.0.0.

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
  (`omarchy/default/agents/skills/omarchy/SKILL.md`).
- The installer writes a limited passwordless-sudo allowlist to
  `/etc/sudoers.d/first-run` (see `install/preflight/first-run-mode.sh`). Do not
  broaden it beyond the listed commands.

# Migrations

Migrations are a deliberate deviation from Omarchy: they are not ported, and
`omarchy-migrate` / `ub-dev-add-migration` will not exist here. Do not add a
migration runner or `migrations/` directory. For state repair, use idempotent
`apply-*`/`setup-*` commands or fold the repair into the `ub-update` path
instead. This is a smaller deviation than it looks: v4.0.4 reduced `migrations/`
from 330 files to roughly 106 and moved the remaining ones behind
`~/.local/state/omarchy/migrations/` markers, so `omarchy/docs/migrations.md`
describes a much lighter model than the v3.8.4 one this port was written
against.

# Config Structure

- `config/` - default configs copied to `~/.config/`
- `default/themed/*.tpl` - templates with `{{ variable }}` placeholders for theme colors
- `themes/*/colors.toml` - theme color definitions using semantic names:
  `mode`, `accent`, `selection`, `muted`, the `background`/`foreground`
  families (`dark_*`, `light_*`, `bright_*`), and named colors
  (`red`/`green`/`yellow`/`blue`/`magenta`/`cyan`/`orange`/`brown` plus
  `bright_*` variants). The old `color0-15` palette is legacy.
- `shell/` - the ported Quickshell shell (upstream `omarchy/shell/`), a single
  long-running instance that owns the bar, menus, notifications, OSD, lock,
  wallpaper, and polkit agent. It is **active**: `ub-launch-shell` runs from
  `default/hypr/autostart.lua`, and every surface it provides has been cut
  over from Waybar, Walker/Elephant, Mako, SwayOSD, swaybg, hyprlock, and
  the GNOME polkit agent. `config/ubuntu/shell.json` carries no
  `disabledPlugins`; it
  only sets the bar layout and idle timings. Add a plugin there rather than
  starting a second process for the same job.

## Hyprland Lua

The Hyprland tree matches upstream v4.0.4's Hyprland Lua model and carries no
hyprlang `.conf` files except the non-Hyprland ones (`hypridle.conf`,
`hyprsunset.conf`, `xdph.conf`, and the SDDM greeter at
`default/sddm/hyprland.conf`, which the greeter loads by explicit `--config`
path). Upstream dropped hyprlock with the shell lock and the port followed:
`ub-system-lock` drives the shell's lock surface through
`ub-shell lock lock`, the base package list ships no hyprlock, and the
fingerprint commands touch only PAM.

- `config/hypr/hyprland.lua` is the user entry point. It loads
  `default/hypr/ubuntu.lua` for the ported defaults and
  `hypr/{monitors,input,bindings,looknfeel,autostart}.lua` for user
  overrides.
- `default/hypr/` mirrors upstream's module tree: `bootstrap.lua`,
  `paths.lua`, `require_all.lua`/`require_optional.lua`, `helpers.lua`,
  then `envs`, `input`, `looknfeel`, `windows`, `apps`, `bindings`,
  `toggles`, and `autostart`. `plain-bindings.lua` is the reduced set
  `ub-remove-preinstalls` restores into `~/.config/hypr/bindings.lua`.
- Persistent toggles are Lua files under
  `~/.local/state/ubuntu/toggles/hypr/`, loaded by `toggles.lua` with
  `reload` so order matters. Never read them out of `~/.local/share`.
- Generated flags are a code-injection surface: writer scripts must
  sanitize connector/device names (`^[A-Za-z0-9._-]+$`) before writing
  `hl.monitor(...)`/`hl.device(...)` Lua, and device names go into
  `*-disabled-name` data files read by `disabled-input-device.lua`, never
  into generated Lua.
- `config/hypr/.luarc.json` points editors at `/usr/share/hypr/stubs` and
  declares the `hl`/`o` globals; keep it in `ub-refresh-hyprland`.
- `input.lua` reads `/etc/vconsole.conf` for layouts, so the install-time
  `detect-keyboard-layout.sh` patching step was dropped, as upstream does.
- Deliberate non-ports see plank details in the gaps list below: no
  `nvidia.lua` (NVIDIA envs go to the uwsm session env via
  `install/config/hardware/nvidia.sh`), no upstream
  `workspace-layouts.lua`, no webapp dispatcher branches, and no preinstalled
  application binding gates.

## Shell

The shell is ported from upstream with mechanical renames, and the following
are the only substantive deviations. Everything else stays byte-comparable with
`omarchy/shell/` so a re-pin is a fresh diff rather than a re-port.

- `$UBUNTU_PATH` replaces `$OMARCHY_PATH`; `~/.config/ubuntu/` and
  `~/.local/state/ubuntu/` replace the `omarchy/` equivalents; plugin IDs are
  `ubuntu.*` rather than `omarchy.*`. `ubuntu.*` is therefore the reserved
  namespace, which `ub-plugin-validate` enforces.
- The manifest schema key is `ubuntu:`, not `omarchy:` — `PluginRegistry.qml`
  reads `manifest.ubuntu` for `capabilities` and `clonedFrom`.
- quickshell 0.3.2 rejects `transient` as a reserved QML token, so
  `plugins/notifications/Service.qml` names that local `transientHint`. Upstream
  builds against quickshell-git and needs no rename; revert it if the pacscript
  ever moves to a git build. See the comment at the rename site.
- `MenuModel.js` builds its package-guard index with `dpkg-query` rather than
  `pacman -Qq`. There is no provides set to fold in and no version-constraint
  form, so those two upstream branches are dropped rather than translated.
- The icon font family is referenced as `ubuntu`, but no `ubuntu.ttf` is
  shipped yet, so glyphs fall back. Upstream ships `default/fonts/omarchy/`.
- Only the core plugin set is carried: `bar`, `menu`, `notifications`, `osd`,
  `lock`, `polkit`, `background`, `services/{battery,idle,media,nightlight}`,
  and panels `audio`, `bluetooth`, `clock`, `monitor`, `network`, `power`.
  Deferred: `agents`, `clipboard`, `dev-gallery`, `emojis`, `image-picker`,
  `reminders`, and panels `disk-speedtest`, `dropbox`, `speedtest`, `tailscale`,
  `weather`, `wifiqr`. `config/ubuntu/shell.json` is trimmed to match.
- `plugins/menu/Menu.qml` carries three port-only providers — `themes`,
  `backgrounds`, and `unlocks` — ported from the Elephant menus this setup used
  to ship as `default/elephant/ubuntu_{themes,background_selector,unlocks}.lua`.
  Each is a bash one-liner emitting the `label\tvalue\tcurrent` rows the other
  providers use. Add new ones here rather than as separate scripts: only
  providers in that `providers` map are runnable in this Quickshell version.
- `ub-audio-output-volume` is ported from upstream but simplified: upstream
  resolves the physical sink through a chain of `omarchy-audio-*` helpers
  before touching pactl, and this port has no DSP-routing layer to resolve
  through, so it drives `@DEFAULT_SINK@` directly, matching the pactl idiom
  already in `ub-audio-output-switch`. The mute-toggle debounce state file
  moves from `/tmp/omarchy-*` to `~/.local/state/ubuntu/`.
- OSD icon names are the shell's own set (`volume-muted`, `microphone`,
  `keyboard`, `brightness`, `touchpad`, `touchscreen`), not SwayOSD's
  `*-symbolic` names; `OsdModel.iconFor` maps them to glyphs.
- The shell reads the theme from `~/.config/ubuntu/current`, not
  `~/.local/state/omarchy/current`. Upstream's location exists because that
  tree is generated by a render stage; this port has none, and `ub-theme-set`
  swaps that directory in place, so the shell reads where it writes. Only the
  theme paths moved — the shell's own runtime state (`toggles/`,
  `notifications/`, `indicators/`) stays under `~/.local/state/ubuntu/`,
  which is already where `ub-toggle-enabled` puts its flag files.
- `ub-theme-render-shell` is upstream's `theme-set-templates` reduced to the
  one template this setup needs. Upwright's is a full render stage (staging
  tree, `colorN` aliases, user template directory, every template);
  this renders only `default/themed/shell.toml.tpl`, only the tokens it uses,
  and leaves anything it does not recognise in place so a mistake shows as a
  visible `{{ }}` rather than a silently wrong color. `shell_gradient()`
  reads `hyprland_active_border` from `colors.toml` rather than asking
  Hyprland, because `col.active_border` is a config variable and `hyprctl
  getoption` reports "no such option" for it either way.
- Launch and IPC: `ub-launch-shell` supervises the instance the way upstream's
  launcher does; `ub-shell` is the IPC client (`qs ipc ... call --`). Both read
  `$UBUNTU_PATH` from the uwsm session environment, which is set at login and
  is not exported by `install.sh` — see `# Runtime Environment`.

# Theming

Omarchy's theming is a deliberate deviation and is not ported wholesale. Do not
port `omarchy/install/config/theme.sh` verbatim, upstream's `themes/`
directory, or the template-rendering and per-appsetter machinery
(`omarchy-theme-set-templates`, `omarchy-theme-set-{foot,gnome,browser,vscode,obsidian,keyboard}`,
the `color0-15` palette and theme-selection machinery do not apply).

- Upstream v4.0.4 replaced the single `install/config/theme.sh` with a pair:
  `install/config/theme-system.sh` owns the staged render into
  `~/.local/state/omarchy/current/`, while `install/user/theme.sh` does the
  per-user setup. Both carry Chromium-specific work — a `SingletonLock` clear
  and, via `install/config/browser-policy.sh`, managed policy files. Porting
  either verbatim would drag in a browser this project does not use.
- Any theming this project does have is our own, described under
  `# Config Structure`: `themes/*/colors.toml` with semantic color names, and
  `default/themed/*.tpl` templates.
- The minimal local commands that the Elephant menus and Hypr configs depend
  on are in scope: `ub-theme-set` (atomic `~/.config/ubuntu/current` swap only),
  `ub-theme-bg-set`, and the `ub-plymouth-*` trio. Keep them free of template
  rendering and per-app setters; theme content seeding is separate work. Note
  that upstream's own `omarchy-shell` bar and menus read the rendered theme, so
  a swap-only `ub-theme-set` will not follow upstream once the shell lands.

# Refresh Pattern

To copy a default config to user config with automatic backup:

```bash
ub-refresh-config hypr/hyprland.lua
```

This copies the default config to `~/.config/hypr/hyprland.lua`. The argument
is interpolated into both paths and only checked with `[[ -e ]]`, so pass a
plain relative path: a name containing `..` resolves and copies, landing outside
`~/.config` rather than being rejected.

Upstream v4.0.4 renamed the Hyprland files from `.conf` to `.lua` and added
`omarchy-refresh-hyprland` / `omarchy-refresh-shell` while dropping the
`waybar`/`walker`/`swayosd`/`hyprlock` refreshers along with those apps. This
port has the same shape: `ub-refresh-hyprland` refreshes the user Lua files,
`hypr/.luarc.json`, and `xdph.conf`, then re-seeds the toggle flags.

# Tests

Automated tests are not ported yet. The Omarchy model to follow:

- `./test/all` - aggregate runner for CLI and shell tests (no graphical tests)
- `./test/cli` - CLI routing, command metadata, theme helpers, and safe dispatch
  coverage, using TAP-style `pass`/`fail` output and `timeout` on help dispatch
- `./test/shell` - runs every `test/shell.d/*-test.sh`; source
  `test/shell.d/base-test.sh` for shared assertions
- Tests enforce that `bin/` never uses raw `command -v` or bare `notify-send`
  (helpers must be used)
- Upstream also has `test/acceptance.d/`, a graphical suite that runs in a
  disposable VM. It is out of scope here and deliberately excluded from
  `./test/all`, matching upstream's own aggregate runner.

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
  ported; see the bullets below. Upstream v4.0.4 narrowed `install/login/` to
  just `all.sh` and `sddm.sh` and moved plymouth, default-keyring, and the
  snapper setup to `install/user/`, `install/config/snapper.sh`, and `etc/`.
- `config/` holds the ported Hyprland tree (`config/hypr/`), the uwsm session
  env (`config/uwsm/`), a fontconfig default for `ub-font-set`, hook samples
  under `config/ubuntu/hooks/`, and defaults for the apps the desktop actually
  launches or offers: `fcitx5` plus its `environment.d` variables,
  `foot`/`ghostty`/`kitty`,
  `alacritty`, `starship`, `tmux`, `fastfetch`, `git`, `wiremix`,
  `opencode`, Typora themes, and the share picker. `imv` and `xournalpp`
  are not installed, so their configs are absent. `waybar/`, `walker/`,
  `elephant/`, `mako/`, and `swayosd/` are gone: those surfaces belong to the
  shell now. The rest — `uwsm/`, `fastfetch/`, `fontconfig/`, and `Typora` —
  are still carried here and are still upstream's to replace.
- `btop` and `lazygit` are installed and launched from the TUI bindings, but
  ship no `config/`. Upstream's `config/btop/btop.conf` and
  `config/lazygit/config.yml` are deliberately not carried: both apps fall
  back to sane built-in defaults, and the port keeps app-specific tuning out
  of its config tree. `ub-restart-btop` still exists, but with no ported
  config there is nothing theme-specific for it to reload.
- Per-app theme files are deliberately not rendered; see `# Theming`. Configs
  that upstream pulled their colors from a rendered per-app theme file ship
  with the colors spelled out instead, and say so in a header comment. The
  affected files are `config/{foot,ghostty,kitty}` and
  `config/hyprland-preview-share-picker/config.yaml`. Switching themes
  will not recolor them.
- `themes/` ships Tokyo Night and Catppuccin Latte. Each theme carries the
  files the desktop sources directly (`hyprland.lua`, `gum_env.lua`,
  `colors.toml`, `backgrounds/`),
  pre-rendered rather than templated, so `ub-theme-set` stays a directory
  swap. Keep exactly one `background` and one `foreground` line at the start
  of a key in `colors.toml`: `ub-plymouth-set-by-theme` greps those prefixes
  and passes every match to `ub-plymouth-set` as separate arguments. The shell
  bar, menu, OSD, and notifications do not read any of these: they take their
  colors from `shell.toml`, which `ub-theme-set` renders into the theme
  directory from `colors.toml`. Upstream
  v4.0.4 moved most of that rendered content into `default/themed/*.tpl`
  (`hyprland.lua.tpl`, `shell.toml.tpl`, `gum_env.lua.tpl`, …) and shrank each
  theme directory to `colors.toml` plus `icons.theme`, `neovim.lua`,
  `vscode.json`, `keyboard.rgb`, `shell.lock.toml`, and `backgrounds/`.
- `install/first-run/` is ported and driven by `ub-first-run`. Upstream's
  `cleanup-reboot-sudoers.sh` is dropped because `allow-reboot.sh` is not
  ported and never writes that file, and `install-voxtype.hook` is dropped
  because voxtype is not ported. `firewall.sh` skips the Docker rules when
  `ufw-docker` is absent, since it is not in the Ubuntu archive. Upstream
  v4.0.4 renamed the whole directory to `install/user/first-run/` and carries
  a different set (`audio-tuning`, `enable-user-units`, `gnome-theme`,
  `gtk-primary-paste`, `setup-agent.hook`, `setup-fingerprint.hook`,
  `welcome`, `wifi`).
- `bin/` carries the update and repair lifecycle: `ub-update` (snapshot, git,
  apt, pacstall, prune, post-update hook, restart prompts), `ub-reinstall`,
  `ub-snapshot`, `ub-version`, `ub-state`, and the `ub-refresh-*` family.
  Two things are deliberately absent. `ub-migrate`/`ub-dev-add-migration`
  never existed here; see `# Migrations`. `ub-upload-log` is not ported because
  it posts to omarchy.org, which is not this project's service. Both upstream
  counterparts still exist in v4.0.4 (`omarchy-migrate`,
  `omarchy-dev-add-migration`, `omarchy-upload-log`).
- `ub-refresh-config` is the recovery path for `config.sh`'s copy. It backs up,
  replaces, prints the diff, and drops the backup when nothing changed. Do not
  replace it with a plain copy: that is the only way back from a re-run.
- The update pipeline has no AUR or migration step. `ub-update-pacstall` covers
  what `pacman -Syua` did upstream, and there is no migration runner.
- There are no release channels. Upstream's `branch-set`, `channel-set`,
  `version-branch`, and `version-channel` are not ported: this setup tracks a
  git branch plus apt, so `ub-update-available` compares local and remote HEAD
  rather than release tags, and `ub-version-pkgs` reports the last apt upgrade.
  Note that v4.0.4 dropped `branch-set` upstream while keeping the other three.
- Upstream's `update-keyring` is not ported. It maintains `archlinux-keyring`
  through `pacman-key`; Ubuntu's repository keys ship with `ubuntu-keyring` and
  are refreshed by the `apt update` that `ub-update-system-pkgs` already runs.
  `update-without-idle` is likewise absent, because v4.0.4 removed it upstream
  entirely, and `ub-update-perform` manages idle itself.
- `setup-security-fido2` and `remove-security-fido2` are not ported. They edit
  `pam_u2f.so` into `/etc/pam.d/sudo` and `polkit-1`, but Ubuntu 26.04 ships no
  PAM module providing `pam_u2f.so` — only the `libfido2` libraries and
  `fido2-tools`. The fingerprint equivalent is ported, and Ubuntu splits it
  differently: `pam_fprintd.so` lives in `libpam-fprintd`, not `libfprint`.
- `ub-debug` deliberately has no upload option. Upstream posts the log to
  `logs.omarchy.org`, which is not this project's service.
- Theming is minimal by design; see `# Theming`. `config/all.sh` does
  not reference a `theme.sh` (upstream v4.0.4's `install/config/all.sh` runs
  `theme-system.sh`, and the per-user half is `install/user/theme.sh`).
- `install/packaging/webapps.sh` and the `ub-launch-webapp` /
  `ub-launch-or-focus-webapp` helpers are not ported (webapps are
  intentionally omitted from this setup). Upstream v4.0.4 deleted the whole
  `install/packaging/` directory but still ships the `webapp-*` and
  `launch-webapp` commands.
- Two Hyprland bindings were dropped with the Walker/Elephant cutover rather
  than pointed at nothing: `SUPER CTRL, E` (emoji picker) and `SUPER CTRL, V`
  (clipboard manager) both launched an Elephant provider that has no equivalent
  here. They come back with the shell's deferred `emojis` and `clipboard`
  plugins, which are the upstream equivalents of those providers.
- A set of optional third-party `install-*` / `remove-*` commands is
  deliberately not ported. Each either needs a package this setup does not
  carry, depends on a command already omitted above, or serves a workflow
  outside the target spec:
  - `install-service-dropbox` (renamed from `install-dropbox` upstream in
    v4.0.0) — Dropbox ships no official Linux client package, and v4.0.4's
    version additionally registers a shell plugin via
    `omarchy-plugin-enable omarchy.dropbox`. Out of scope for a desktop whose
    only cloud integration is what `ub-install-tailscale` and Firefox already
    provide.
  - `install/remove-gaming-{geforce-now,lutris}` — `geforce-now` downloads and
    runs a vendor `.bin` installer and calls `omarchy-launch-browser`;
    `lutris` pulls the Arch wine stack (`wine-staging`, `wine-mono`,
    `wine-gecko`, `umu-launcher`) and calls
    `omarchy-install-gaming-gpu-lib32`. Neither is part of this setup's
    package set. Upstream's `install/remove-gaming-moonlight` pair is gone in
    v4.0.4, so there is nothing left to decline.
  - `install/remove-gaming-{xbox-cloud,xbox-controllers}` — `xbox-cloud` is
    installed through `omarchy-webapp-install` and launched with
    `omarchy-launch-webapp`, both omitted above because webapps are; the
    controller pair installs the `xpadneo-dkms` module, which has no
    counterpart in the Ubuntu archive. Grouped together since they are one
    Xbox support surface upstream.
  - `install-service-nordvpn` (renamed from `install-nordvpn`) — installs the
    AUR-only `nordvpn-bin`, and this port has no AUR path (see
    `ub-update-pacstall`); `ub-install-tailscale` is the VPN story here.
  - `install-editor-vscode` (renamed from `install-vscode`) — installs the
    AUR `visual-studio-code-bin` and then calls `omarchy-theme-set-vscode`,
    which is excluded by `# Theming`.
  - `install-editor-zed` (renamed from `install-zed`) — installs the AUR `zed`
    / `omazed` packages and applies the theme through `omazed setup`, same two
    blockers as VS Code.
  - `install-service-once` (renamed from `install-once`) — installs the AUR
    `once-bin` and enables `once-background.service`; no AUR path, no service
    in the base set.
  - `windows-vm` — drives a `dockurr/windows` container over Docker plus
    `xfreerdp3`, well outside a btrfs/zram desktop install.
  - `remove-gaming-minecraft` — has no upstream `install-` counterpart, so
    there is nothing to port a removal for.
- Still-open future work rather than deliberate omissions: `install-browser`,
  `install-chromium-google-account`, `remove-browser`, and
  `install/remove-gaming-{gpu-lib32,heroic,retroarch,steam}`. These have no
  blocking dependency identified and are the next candidates if the
  optional-software surface grows. Note that `install-gaming-gpu-lib32` is what
  `install-gaming-lutris` calls, so porting Lutris later means porting it too.
- `install/config/hardware/nvidia.sh` appends its NVIDIA environment block to
  `~/.config/uwsm/env` (sourced at login), following upstream's migration in
  commit `638e35fc` away from the never-sourced `config/hypr/envs.conf`. Upstream
  v4.0.4 has since moved this to `install/hardware/nvidia.sh` and hands the
  per-session env to `default/hypr/nvidia.lua`.
- `install/config/config.sh` copies `config/` over `~/.config/` unconditionally,
  so re-running the installer discards hand edits to `~/.config/hypr/*.lua`.
  Answer it with `ub-refresh-config`, which is ported and backs up first.
  Upstream v4.0.4 deleted `config.sh` entirely in favour of the
  seed/finalize/resync model described in `omarchy/docs/file-layout.md`, so
  there is no upstream line to match any more.
- The login stage does not set up hibernation. Upstream's `hibernation.sh` is
  not ported: it calls `omarchy-hibernation-setup`, and hibernation is
  intentionally omitted to match the target spec (no swap, zram enabled).
- `login/limine-snapper.sh` is ported, but rewritten for Ubuntu rather than
  copied. It owns `/boot/limine.conf`, the UKIs, and the snapper snapshot menu;
  the bootloader itself is still deployed by hand (see `README.md`) and
  this script converges an existing install rather than creating one. Upstream's
  Arch plumbing is replaced one-for-one: `mkinitcpio` conf.d -> `initramfs-tools`
  conf.d plus an explicit module list, `limine-mkinitcpio-hook` -> `ukify` driven
  from `/etc/kernel/postinst.d` and `/etc/initramfs/post-update.d`,
  `limine-install` -> copying `BOOTX64.EFI` and registering it with `efibootmgr`,
  and the `libalpm` re-enable step is dropped since dpkg kernel hooks always run.
  Two constraints are worth keeping in mind when editing it. First, exactly two
  things write `/boot/limine.conf`: this script's kernel entries and
  `limine-snapper-sync`'s snapshot entries. Do not adopt upstream v4.0.4's
  `limine-entry-tool` (it ships in `etc/limine-entry-tool.d/` and has
  `/etc/boot/hooks` automation) without first disabling that automation, or it
  becomes a third writer. Second, UKIs are built unsigned, which is sound only
  because `install/preflight/guard.sh` hard-aborts on Secure Boot being enabled.
- `install/default/snapper/root` is installed by `login/limine-snapper.sh`.
  Upstream v4.0.4 keeps the template at `default/snapper/root` and installs it
  from `install/config/snapper.sh`.
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
  skill and pi-agent extension, neither of which this port carries. The first
  three still exist upstream in v4.0.4; the last three were dropped upstream
  too.
- Of upstream's generic hardware fixes, three are ported: `network.sh`
  (enables iwd and masks `systemd-networkd-wait-online`), `fix-fkeys.sh`, and
  `fix-synaptic-touchpad.sh`. The rest need packages absent from the archive
  (`broadcom-wl`, `yt6801-dkms`, `tuxedo-drivers-nocompatcheck-dkms`) or
  mkinitcpio configuration. `set-wireless-regdom.sh` is dropped rather than
  translated: it targets CRDA's `/etc/conf.d/wireless-regdom`, and Ubuntu has
  dropped CRDA without a documented equivalent config path for iwd. Upstream
  v4.0.4 moved all of these from `install/config/hardware/` to a top-level
  `install/hardware/` and grew the set well past the original eight.
- DNS policy is `ub-dns`, ported from upstream v4.0.0's DNS command rather than
  the v3.8.4 `setup-dns` it replaced there. It configures three layers because
  NetworkManager is the network manager here: a `conf.d` global DNS entry,
  per-connection `ipv4/ipv6.ignore-auto-dns`, and `systemd-resolved.conf`.
  Writing only `resolved.conf`, as the 3.8.4 version did, would be silently
  overridden by NM's per-connection settings. `install/first-run/dns-resolver.sh`
  is separate and still needed: it only ensures `/etc/resolv.conf` points at the
  resolved stub, which is plumbing rather than provider policy. Upstream v4.0.4
  has no `install/first-run/` at all, so there is no counterpart to point at.
- The hardware-specific packaging scripts (`asus-rog.sh`, `framework16.sh`,
  `surface.sh`, `dell-xps-touchpad-haptics.sh`) are not ported; every package
  they install (`asusctl`, `qmk-hid`, `linux-firmware-marvell`,
  `dell-xps-touchpad-haptics`, …) is absent from Ubuntu 26.04. In v4.0.4 these
  live in `install/hardware/` rather than `install/packaging/`.
- The vendor `install/config/hardware/` trees (`intel/`, `asus/`,
  `framework/`, `apple/`, `lenovo/`) are not ported either: the package-backed
  fixes have nothing to install, and the package-free ones were triaged out
  with them rather than carried without their detectors. Upstream v4.0.4 moved
  them to `install/hardware/{intel,asus,framework,apple,lenovo}/` and grew
  each set.
- The vendor `ub-hw-*` detection helpers (`hw-intel*`, `hw-asus-*`,
  `hw-framework16`, `hw-surface`, `hw-dell-xps-*`, `hw-hybrid-gpu`, `hw-vulkan`)
  are deliberately omitted as well. Each exists upstream only to gate one of
  the scripts above, and carrying detectors for hardware this setup does not
  support would invite wiring them into menus and install stages that can never
  fire. The generic `ub-hw-match` (DMI string match) stays and covers the
  model-gated fixes that are ported.
- The Apple display commands are omitted for the same reason as
  `sudoless-asdcontrol.sh` above: `ub-brightness-display-apple` and
  `ub-hyprland-monitor-focused-apple` both drive Apple Studio / XDR displays
  through `asdcontrol`, which Ubuntu 26.04 does not package. Neither would
  have anything to detect on hardware this setup supports.
