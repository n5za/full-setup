
local terminal = "kitty"
hl.bind("CTRL+SUPER+ALT+Slash", hl.dsp.exec_cmd("xdg-open ~/.config/hypr/custom/keybinds.lua"), {description = "Edit user keybinds"} )

hl.bind("CTRL + SHIFT + S", hl.dsp.exec_cmd("pidof slurp || hyprshot --freeze --clipboard-only --mode region --silent"),
    { description = "Utilities: Screen snip (Ctrl+Shift+S)" })

hl.bind("SUPER + W", hl.dsp.exec_cmd(terminal), { description = "App: Terminal (Super+W)" })


hl.bind("SUPER + Tab", hl.dsp.focus({ workspace = "m+1" }), {
    description = "Next occupied workspace"
})

hl.bind("ALT + W", hl.dsp.exec_cmd("bash -c '/home/nasa/.config/hypr/scripts/random-wallpaper.sh'"), {
    description = "Random wallpaper"
})
