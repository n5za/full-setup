-- Super tap: jumps to next occupied workspace only on a clean quick tap
hl.on("hyprland.start", function()
    hl.exec_cmd("$HOME/Documents/super_tap_daemon.sh")
    hl.exec_cmd("awww-daemon")
end)
