-- Floating windows.
o.window({ tag = "floating-window" }, { float = true })
o.window({ tag = "floating-window" }, { center = true })
o.window({ tag = "floating-window" }, { size = { 875, 600 } })

o.window(
  "(org.ubuntu.bluetui|org.ubuntu.impala|org.ubuntu.wiremix|org.ubuntu.btop|org.ubuntu.terminal|org.ubuntu.bash|org.codeberg.dnkl.foot|org.gnome.NautilusPreviewer|org.gnome.Evince|com.gabm.satty|Ubuntu|About|TUI.float|imv|mpv)",
  { tag = "+floating-window" }
)
o.window({
  class = "(xdg-desktop-portal-gtk|sublime_text|DesktopEditors|org.gnome.Nautilus)",
  title = "^(Open.*Files?|Open [F|f]older.*|Save.*Files?|Save.*As|Save|All Files|.*wants to [open|save].*|[C|c]hoose.*)",
}, { tag = "+floating-window" })
o.window("org.gnome.Calculator", { float = true })

-- Fullscreen screensaver.
o.window("org.ubuntu.screensaver", { fullscreen = true })
o.window("org.ubuntu.screensaver", { float = true })
o.window("org.ubuntu.screensaver", { animation = "slide" })

-- No transparency on media windows.
o.window(
  "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$",
  { tag = "-default-opacity" }
)
o.window(
  "^(zoom|vlc|mpv|org.kde.kdenlive|com.obsproject.Studio|com.github.PintaProject.Pinta|imv|org.gnome.NautilusPreviewer)$",
  { opacity = "1 1" }
)

-- Popped window rounding.
o.window({ tag = "pop" }, { rounding = 8 })

-- Prevent idle while open.
o.window({ tag = "noidle" }, { idle_inhibit = "always" })
