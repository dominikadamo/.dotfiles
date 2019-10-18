
local theme_name = "ephemeral"
local icon_theme_name = "drops"
local bar_theme_name = "ephemeral"

-- Initialization
-- ===================================================================
-- Theme handling library
local beautiful = require("beautiful")
-- Themes define colours, icons, font and wallpapers
local theme_dir = os.getenv("HOME") .. "/.config/awesome/themes/"
beautiful.init( theme_dir .. theme_name .. "/theme.lua" )
--beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")
local xresources = require("beautiful.xresources")
-- Make dpi function global
dpi = xresources.apply_dpi

local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
require("awful.autofocus")

-- Default notification library
local naughty = require("naughty")

local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")



-- Error handling
-- ===================================================================
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Variable definitions
-- ===================================================================
-- User variables and preferences
user = {
    -- >> Default applications <<
    terminal = "kitty -1",
    floating_terminal = "kitty -1",
    browser = "firefox",
    file_manager = "nemo",
    tmux = "kitty -1 -e tmux new",
    editor = "kitty -1 --class editor -e vim",
    -- editor = "emacs",

    -- >> Search <<
    -- web_search_cmd = "exo-open https://duckduckgo.com/?q="
    web_search_cmd = "xdg-open https://duckduckgo.com/?q=",
    -- web_search_cmd = "exo-open https://www.google.com/search?q="

    -- >> Music <<
    music_client = "kitty -1 --class music -e ncmpcpp",

    -- TODO
    -- >> Screenshots <<
    -- Make sure the directory exists!
    screenshot_dir = os.getenv("HOME") .. "/Pictures/Screenshots/",

    -- >> Email <<
    email_client = "kitty -1 --class email -e neomutt",

    -- >> Anti-aliasing <<
    -- ------------------
    -- Requires a compositor to be running.
    -- ------------------
    -- Currently this works if you set your titlebar position to "top", but it
    -- is trivial to make it work for any titlebar position.
    -- ------------------
    -- This setting only affects clients, but you can "manually" apply
    -- anti-aliasing to other wiboxes. Check out the notification
    -- widget_template in notifications.lua for an example.
    -- ------------------
    -- If anti_aliasing is set to true, the top titlebar corners are
    -- antialiased and a small titlebar is also added at the bottom in order to
    -- round the bottom corners.
    -- If anti_aliasing set to false, the client shape will STILL be rounded,
    -- just without anti-aliasing, according to your theme's border_radius
    -- variable.
    -- ------------------
    anti_aliasing = true,

    -- >> Sidebar <<
    sidebar_hide_on_mouse_leave = true,
    sidebar_show_on_mouse_screen_edge = true,

    -- >> Lock screen <<
    -- You can set this to whatever you want or leave it empty in
    -- order to unlock with just the Enter key.
    lock_screen_password = "awesome",
    -- lock_screen_password = "",

    -- >> Weather <<
    -- Get your key and find your city id at
    -- https://openweathermap.org/
    -- (You will need to make an account!)
    openweathermap_key = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
    openweathermap_city_id = "yyyyyy",
    -- Use "metric" for Celcius, "imperial" for Fahrenheit
    weather_units = "metric",
}



-- Features
-- ===================================================================
-- Basic
-- ================
-- Load icon theme
icons = require("icons")
icons.init(icon_theme_name)
-- Helper functions
-- What would I do without them?
local helpers = require("helpers")
-- Keybinds and mousebinds
local keys = require("keys")
-- Titlebars
-- (most of the anti-aliasing magic happens here)
require("titlebars")
-- Notification settings
require("notifications")


-- Extras
-- ==============
-- Statusbar(s)
require("bars."..bar_theme_name)
-- Sidebar
local sidebar = require("noodle.sidebar")

-- Exit screen
-- local exit_screen = require("noodle.exit_screen")
local exit_screen = require("noodle.exit_screen_v2")
-- Start screen
-- Have not used/tested it in a long time.
-- Some things might not work properly.
local start_screen = require("noodle.start_screen")

-- Lock screen
-- Make sure to configure your password in the 'user' section above
local lock_screen = require("noodle.lock_screen")

-- App drawer
local app_drawer = require("noodle.app_drawer")

-- Daemons
-- Most widgets that display system info depend on evil
require("evil")

-- Get screen geometry
screen_width = awful.screen.focused().geometry.width
screen_height = awful.screen.focused().geometry.height

-- Layouts
-- ===================================================================
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}


-- Menu
-- ===================================================================
-- Create a launcher widget and a main menu
myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end, icons.keyboard},
    { "restart", awesome.restart, icons.reboot },
    { "quit", function() exit_screen_show() end, icons.poweroff}
}

mymainmenu = awful.menu({
    items = {
        { "awesome", myawesomemenu, icons.home },
        { "firefox", user.browser, icons.firefox },
        { "terminal", user.terminal, icons.terminal },
        { "files", user.file_manager, icons.files },
        { "search", "rofi -matching fuzzy -show combi", icons.search },
    }
})

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu
})

-- Menubar configuration
menubar.utils.terminal = user.terminal -- Set the terminal for applications that require it

-- Wallpaper
-- ===================================================================
local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end

        -- Method 1: Built in wallpaper function
        -- gears.wallpaper.fit(wallpaper, s, true)
        -- gears.wallpaper.maximized(wallpaper, s, true)

        -- Method 2: Set theme's wallpaper with feh
        --awful.spawn.with_shell("feh --bg-fill " .. wallpaper)

        -- Method 3: Set last wallpaper with feh
        awful.spawn.with_shell(os.getenv("HOME") .. "/.fehbg")
    end
end


-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

-- Tags
-- ===================================================================
awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    local l = awful.layout.suit -- Alias to save time :)
    -- Tag layouts
    local layouts = {
        l.tile,
        l.tile,
        l.tile,
        l.tile,
        l.tile,
        l.tile,
        l.tile,
        l.tile,
        l.tile,
        l.max
    }

    -- Tag names
    local tagnames = beautiful.tagnames or { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10" }
    -- Create all tags at once (without seperate configuration for each tag)
    awful.tag(tagnames, s, layouts)


end)

-- Determines how floating clients should be placed
local client_placement_f = awful.placement.no_overlap + awful.placement.no_offscreen

-- Rules
-- ===================================================================
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    {
        -- All clients will match this rule.
        rule = { },
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = keys.clientkeys,
            buttons = keys.clientbuttons,
            -- screen = awful.screen.preferred,
            screen = awful.screen.focused,
            size_hints_honor = false,
            honor_workarea = true,
            honor_padding = true,
            -- placement = awful.placement.no_overlap+awful.placement.no_offscreen
        },
        callback = function (c)
            if not awesome.startup then
                -- If the layout is floating or there are no other visible clients
                -- Apply placement function
                if awful.layout.get(mouse.screen) ~= awful.layout.suit.floating or #mouse.screen.clients == 1 then
                    awful.placement.centered(c,{honor_padding = true, honor_workarea=true})
                else
                    client_placement_f(c, {honor_padding = true, honor_workarea=true, margins = beautiful.useless_gap * 2})
                end

                -- Hide titlebars if required by the theme
                if not beautiful.titlebars_enabled then
                    decorations.hide(c)
                    -- awful.titlebar.hide(c)
                end

            end
        end
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { "normal", "dialog" } },
        properties = { titlebars_enabled = false }
    },

    -- Floating clients
    {
        rule_any = {
            instance = {
                "DTA",  -- Firefox addon DownThemAll.
                "copyq",  -- Includes session name in class.
                "floating_terminal",
            },
            class = {
                "mpv",
                "Gpick",
                "Lxappearance",
                "Nm-connection-editor",
                "File-roller",
                "fst",
            },
            name = {
                "Event Tester",  -- xev
            },
            role = {
                "AlarmWindow",
                "pop-up",
                "GtkFileChooserDialog",
                "conversation",
            },
            type = {
                "dialog",
            }
        },
        properties = { floating = true, ontop = false }
    },

    ---------------------------------------------
    -- Start application on specific workspace --
    ---------------------------------------------
    -- Browsing
    {
        rule_any = {
            class = {
                "Firefox",
                "qutebrowser",
            },
        },
        except_any = {
            role = { "GtkFileChooserDialog" },
            type = { "dialog" }
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[1] },
    },

    -- Games
    {
        rule_any = {
            class = {
                "dota2",
                "Terraria.bin.x86",
                "dontstarve_steam",
                "Wine",
            },
        },
        properties = { screen = 1, tag = awful.screen.focused().tags[2] }
    },


}
-- (Rules end here) ..................................................
-- ===================================================================

-- Signals
-- ===================================================================
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set every new window as a slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end

    -- if awesome.startup
    -- and not c.size_hints.user_position
    -- and not c.size_hints.program_position then
    --     -- Prevent clients from being unreachable after screen count changes.
    --     awful.placement.no_offscreen(c)
    --     awful.placement.no_overlap(c)
    -- end

end)

-- Apply rounded corners to clients
-- (If antialiasing is enabled, the rounded corners are applied in
-- titlebars.lua)
if not user.anti_aliasing then
    if beautiful.border_radius ~= 0 then
        client.connect_signal("manage", function (c, startup)
            if not c.fullscreen and not c.maximized then
                c.shape = helpers.rrect(beautiful.border_radius)
            end
        end)

        -- Fullscreen and maximized clients should not have rounded corners
        local function no_round_corners (c)
            if c.fullscreen or c.maximized then
                c.shape = gears.shape.rectangle
            else
                c.shape = helpers.rrect(beautiful.border_radius)
            end
        end

        client.connect_signal("property::fullscreen", no_round_corners)
        client.connect_signal("property::maximized", no_round_corners)

        beautiful.snap_shape = helpers.rrect(beautiful.border_radius * 2)
    else
        beautiful.snap_shape = gears.shape.rectangle
    end
end

if beautiful.taglist_item_roundness ~= 0 then
    beautiful.taglist_shape = helpers.rrect(beautiful.taglist_item_roundness)
end

if beautiful.notification_border_radius ~= 0 then
    beautiful.notification_shape = helpers.rrect(beautiful.notification_border_radius)
end

-- When a client starts up in fullscreen, resize it to cover the fullscreen a short moment later
-- Fixes wrong geometry when titlebars are enabled
--client.connect_signal("property::fullscreen", function(c)
client.connect_signal("manage", function(c)
    if c.fullscreen then
        gears.timer.delayed_call(function()
            if c.valid then
                c:geometry(c.screen.geometry)
            end
        end)
    end
end)
-- Set mouse resize mode (live or after)
awful.mouse.resize.set_mode("live")

-- Restore geometry for floating clients
-- (for example after swapping from tiling mode to floating mode)
-- ==============================================================
tag.connect_signal('property::layout', function(t)
    for k, c in ipairs(t:clients()) do
        if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
            -- Geometry x = 0 and y = 0 most probably means that the client's
            -- floating_geometry has not been set yet.
            -- If that is the case, don't change their geometry
            -- TODO does this affect clients that are really placed in 0,0 ?
            local cgeo = awful.client.property.get(c, 'floating_geometry')
            if cgeo and not (cgeo.x == 0 and cgeo.y == 0) then
                c:geometry(awful.client.property.get(c, 'floating_geometry'))
            end
            --c:geometry(awful.client.property.get(c, 'floating_geometry'))
        end
    end
end)

client.connect_signal('manage', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)

client.connect_signal('property::geometry', function(c)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating then
        awful.client.property.set(c, 'floating_geometry', c:geometry())
    end
end)
-- Make rofi able to unminimize minimized clients
client.connect_signal("request::activate", function(c, context, hints)
    if not awesome.startup then
        if c.minimized then
            c.minimized = false
        end
        awful.ewmh.activate(c, context, hints)
    end
end)

-- Disconnect the client ability to request different size and position
-- client.disconnect_signal("request::geometry", awful.ewmh.client_geometry_requests)

-- Startup applications
-- Runs your autostart.sh script, which should include all the commands you
-- would like to run every time AwesomeWM restarts
-- ===================================================================
awful.spawn.with_shell( os.getenv("HOME") .. "/.config/awesome/autostart.sh")

-- Garbage collection
-- Enable for lower memory consumption
-- ===================================================================

-- collectgarbage("setpause", 160)
-- collectgarbage("setstepmul", 400)

-- collectgarbage("setpause", 110)
-- collectgarbage("setstepmul", 1000)

-- {{ Function to ensure that certain programs only have one
-- instance of themselves when i restart awesome

function run_once(cmd)
        findme = cmd
        firstspace = cmd:find(" ")
        if firstspace then
                findme = cmd:sub(0, firstspace-1)
        end
    awful.spawn.with_shell("pgrep -u $USER -x " .. findme .. " > /dev/null || (" .. cmd .. ")")
end

os.execute("xbacklight -set 25 -time 1000")

-- {{ I need redshift to save my eyes }} -
run_once("redshift -l 52.51:13.31")
run_once("sleep 1 && ~/setscale auto")
run_once("nm-applet")
-- os.execute("compton -b")
os.execute("xset -dpms && xset s off")
-- awful.util.spawn_with_shell("xmodmap ~/.speedswapper")

-- {{ Turns off the terminal bell }} --
-- awful.util.spawn_with_shell("/usr/bin/xset b off")

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
