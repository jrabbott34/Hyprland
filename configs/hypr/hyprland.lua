-- hyprland.lua — Minimalist Hyprland config for Arch Linux
-- Catppuccin Mocha theme
-- https://wiki.hypr.land/


-------------------
---- MONITORS ----
-------------------
-- Use `hyprctl monitors` to list connected monitors.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "auto" })
-- Dual monitor example:
-- hl.monitor({ output = "DP-1",     mode = "2560x1440@144", position = "0x0",    scale = "auto" })
-- hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60",  position = "2560x0", scale = "auto" })


-------------------
---- AUTOSTART ----
-------------------
hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("/usr/lib/xdg-desktop-portal-hyprland")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
hl.env("XCURSOR_SIZE",                        "24")
hl.env("XCURSOR_THEME",                       "Adwaita")
hl.env("QT_QPA_PLATFORM",                     "wayland")
hl.env("QT_QPA_PLATFORMTHEME",                "qt6ct")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("GDK_BACKEND",                         "wayland,x11")
hl.env("SDL_VIDEODRIVER",                     "wayland")
hl.env("CLUTTER_BACKEND",                     "wayland")
hl.env("XDG_CURRENT_DESKTOP",                 "Hyprland")
hl.env("XDG_SESSION_TYPE",                    "wayland")
hl.env("XDG_SESSION_DESKTOP",                 "Hyprland")
hl.env("MOZ_ENABLE_WAYLAND",                  "1")


-----------------------
---- LOOK AND FEEL ----
-----------------------
hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 2,

        col = {
            -- Catppuccin Mocha: blue → purple gradient
            active_border   = { colors = { "rgba(89b4faee)", "rgba(cba6f7ee)" }, angle = 45 },
            inactive_border = "rgba(45475aaa)",
        },

        layout        = "dwindle",
        allow_tearing = false,
    },

    decoration = {
        rounding         = 8,
        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        shadow = {
            enabled      = true,
            range        = 12,
            render_power = 3,
            color        = 0xee1a1a2e,
        },

        blur = {
            enabled  = true,
            size     = 4,
            passes   = 2,
            vibrancy = 0.1696,
        },
    },
})

-- Bezier curves
hl.curve("smooth",   { type = "bezier", points = { { 0.05, 0.9  }, { 0.1,  1.05 } } })
hl.curve("linear",   { type = "bezier", points = { { 0,    0    }, { 1,    1    } } })
hl.curve("overshot", { type = "bezier", points = { { 0.13, 0.99 }, { 0.29, 1.1  } } })

-- Animations
hl.animation({ leaf = "windows",    enabled = true, speed = 5,  bezier = "smooth",  style = "slide"     })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 5,  bezier = "smooth",  style = "popin 80%" })
hl.animation({ leaf = "border",     enabled = true, speed = 10, bezier = "linear"                       })
hl.animation({ leaf = "fade",       enabled = true, speed = 5,  bezier = "smooth"                       })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5,  bezier = "overshot"                     })

-- Layout options
hl.config({
    dwindle = {
        preserve_split = true,
    },
    master = {
        new_status = "master",
    },
})

-- Misc
hl.config({
    misc = {
        force_default_wallpaper = 0,     -- 0 disables the anime mascot
        disable_hyprland_logo   = true,
        mouse_move_enables_dpms = true,
        key_press_enables_dpms  = true,
        font_family             = "FiraCode Nerd Font",
    },
})

-- Input
hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,
        sensitivity  = 0,

        touchpad = {
            natural_scroll       = false,
            disable_while_typing = true,
        },
    },
})


---------------------
---- KEYBINDINGS ----
---------------------
local mainMod     = "SUPER"
local terminal    = "alacritty"
local fileManager = "thunar"
local menu        = "wofi --show drun"
local browser     = "firefox"

-- Core
hl.bind(mainMod .. " + Return",    hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",         hl.dsp.window.close())
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + B",         hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + F",         hl.dsp.exec_cmd("hyprctl dispatch fullscreen"))
hl.bind(mainMod .. " + V",         hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + J",         hl.dsp.layout("togglesplit"))

-- Session
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.exec_cmd("wlogout"))
hl.bind(mainMod .. " + L",         hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("hyprctl dispatch exit"))

-- Caffeine (inhibit idle/sleep)
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("~/.config/hypr/scripts/caffeine-toggle.sh"))

-- Screenshots
hl.bind("Print",
    hl.dsp.exec_cmd([[grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot" "Copied to clipboard"]]))
hl.bind(mainMod .. " + Print",
    hl.dsp.exec_cmd([[grim ~/Pictures/screenshots/$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot" "Saved"]]))
hl.bind(mainMod .. " + SHIFT + Print",
    hl.dsp.exec_cmd([[grim -o "$(hyprctl monitors -j | jq -r '.[0].name')" - | wl-copy]]))

-- Move focus — arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down"  }))

-- Move windows — SHIFT + arrows
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch movewindow r"))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.exec_cmd("hyprctl dispatch movewindow d"))

-- Resize — CTRL + arrows
hl.bind(mainMod .. " + CTRL + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 30 0"),  { repeating = true })
hl.bind(mainMod .. " + CTRL + left",  hl.dsp.exec_cmd("hyprctl dispatch resizeactive -30 0"), { repeating = true })
hl.bind(mainMod .. " + CTRL + up",    hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -30"), { repeating = true })
hl.bind(mainMod .. " + CTRL + down",  hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 30"),  { repeating = true })

-- Workspaces — switch and move
for i = 1, 10 do
    local key = i % 10  -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces with mouse wheel
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mouse
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Audio (pipewire/wireplumber)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),         { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),        { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),      { locked = true })

-- Brightness
hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- Suppress maximize requests from all apps
hl.window_rule({
    name           = "suppress-maximize",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

-- Float these apps
hl.window_rule({ name = "float-pavucontrol",  match = { class = "^(pavucontrol)$"           }, float = true, center = true, size = "700 500" })
hl.window_rule({ name = "float-blueman",      match = { class = "^(blueman-manager)$"        }, float = true, center = true, size = "800 600" })
hl.window_rule({ name = "float-nm",           match = { class = "^(nm-connection-editor)$"   }, float = true })
hl.window_rule({ name = "float-lxappearance", match = { class = "^(lxappearance)$"           }, float = true })
hl.window_rule({ name = "float-nwg-look",     match = { class = "^(nwg-look)$"               }, float = true })
hl.window_rule({ name = "float-printer",      match = { class = "^(system-config-printer)$"  }, float = true })
hl.window_rule({ name = "float-file-op",      match = { title = "^(File Operation Progress)$" }, float = true })
hl.window_rule({ name = "float-confirm",      match = { title = "^(Confirm to replace files)$" }, float = true })
hl.window_rule({ name = "float-yad",          match = { class = "^(yad)$"                    }, float = true })

-- Keep LibreOffice tiled
hl.window_rule({ name = "tile-libreoffice",   match = { class = "^(soffice)$"                }, tile = true })
