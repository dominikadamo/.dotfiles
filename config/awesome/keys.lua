local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")

local helpers = require("helpers")

local keys = {}

-- Mod keys
superkey = "Mod4"
altkey = "Mod1"
ctrlkey = "Control"
shiftkey = "Shift"

-- {{{ Mouse bindings on desktop
keys.desktopbuttons = gears.table.join(
    awful.button({ }, 1, function ()
        mymainmenu:hide()
        naughty.destroy_all_notifications()
        local function double_tap()
            uc = awful.client.urgent.get()
            -- If there is no urgent client, go back to last tag
            if uc == nil then
                awful.tag.history.restore()
            else
                awful.client.urgent.jumpto()
            end
        end
        helpers.single_double_tap(function() end, double_tap)
    end),

    -- Right click - Show app drawer
    -- awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 3, function ()
        --app_drawer_show()
    end),

    -- Middle button - Toggle start scren
    awful.button({ }, 2, function ()
        start_screen_show()
    end),

    -- Scrolling - Switch tags
    awful.button({ }, 4, awful.tag.viewprev),
    awful.button({ }, 5, awful.tag.viewnext),

    -- Side buttons - Control volume
    awful.button({ }, 9, function () helpers.volume_control(1) end),
    awful.button({ }, 8, function () helpers.volume_control(-1) end)

    -- Side buttons - Minimize and restore minimized client
    -- awful.button({ }, 8, function()
    --     if client.focus ~= nil then
    --         client.focus.minimized = true
    --     end
    -- end),
    -- awful.button({ }, 9, function()
    --       local c = awful.client.restore()
    --       -- Focus restored client
    --       if c then
    --           client.focus = c
    --           c:raise()
    --       end
    -- end)
)
-- }}}

-- {{{ Key bindings
keys.globalkeys = gears.table.join(
    --awful.key({ superkey,           }, "s",      hotkeys_popup.show_help,
    --{description="show help", group="awesome"}),
    --awful.key({ superkey,           }, "comma",   awful.tag.viewprev,
    --{description = "view previous", group = "tag"}),
    --awful.key({ superkey,           }, "period",  awful.tag.viewnext,
    --{description = "view next", group = "tag"}),

-- {{ Shuts down Computer }} --
    awful.key({ "Control" }, "Escape",
        function()
            awful.util.spawn("systemctl poweroff")
        end,
        {description = "power off computer", group = "client"}),

-- {{ Volume Control }} --

    awful.key({     }, "XF86AudioRaiseVolume", function() awful.util.spawn("amixer set Master 1%+", false) end),
    awful.key({     }, "XF86AudioLowerVolume", function() awful.util.spawn("amixer set Master 1%-", false) end),
    awful.key({     }, "XF86AudioMute", function() awful.util.spawn("amixer set Master toggle", false) end),


-- Focus client by direction (hjkl keys)
    awful.key({ superkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ superkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ superkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ superkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- Focus client by direction (arrow keys)
    awful.key({ superkey }, "Down",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ superkey }, "Up",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ superkey }, "Left",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ superkey }, "Right",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

    -- Focus client by index (cycle through clients)
    -- Double tap: choose client with rofi
    awful.key({ superkey }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ superkey, shiftkey }, "Tab",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),

    -- Gap control
    awful.key({ superkey, shiftkey }, "minus",
        function ()
            awful.tag.incgap(5, nil)
        end,
        {description = "increment gaps size for the current tag", group = "gaps"}
    ),
    awful.key({ superkey }, "minus",
        function ()
            awful.tag.incgap(-5, nil)
        end,
        {description = "decrement gap size for the current tag", group = "gaps"}
    ),
    -- Kill all visible clients for the current tag
    awful.key({ superkey, altkey }, "q",
        function ()
            local clients = awful.screen.focused().clients
            for _, c in pairs(clients) do
                c:kill()
            end
        end,
        {description = "kill all visible clients for the current tag", group = "gaps"}
    ),

    -- Resize focused client or layout factor
    -- (Arrow keys)
    awful.key({ superkey, ctrlkey }, "Down", function (c)
        helpers.resize_dwim(client.focus, "down")
    end),
    awful.key({ superkey, ctrlkey }, "Up", function (c)
        helpers.resize_dwim(client.focus, "up")
    end),
    awful.key({ superkey, ctrlkey }, "Left", function (c)
        helpers.resize_dwim(client.focus, "left")
    end),
    awful.key({ superkey, ctrlkey }, "Right", function (c)
        helpers.resize_dwim(client.focus, "right")
    end),
    -- (Vim keys)
    awful.key({ superkey, ctrlkey }, "j", function (c)
        helpers.resize_dwim(client.focus, "down")
    end),
    awful.key({ superkey, ctrlkey }, "k", function (c)
        helpers.resize_dwim(client.focus, "up")
    end),
    awful.key({ superkey, ctrlkey }, "h", function (c)
        helpers.resize_dwim(client.focus, "left")
    end),
    awful.key({ superkey, ctrlkey }, "l", function (c)
        helpers.resize_dwim(client.focus, "right")
    end),

    -- No need for these (single screen setup)
    --awful.key({ superkey, ctrlkey }, "j", function () awful.screen.focus_relative( 1) end,
    --{description = "focus the next screen", group = "screen"}),
    --awful.key({ superkey, ctrlkey }, "k", function () awful.screen.focus_relative(-1) end,
    --{description = "focus the previous screen", group = "screen"}),
    
    -- Urgent or Undo:
    -- Jump to urgent client or (if there is no such client) go back
    -- to the last tag
    awful.key({ superkey,           }, "u",
        function ()
            uc = awful.client.urgent.get()
            -- If there is no urgent client, go back to last tag
            if uc == nil then
                awful.tag.history.restore()
            else
                awful.client.urgent.jumpto()
            end
        end,
        {description = "jump to urgent client", group = "client"}),

    awful.key({ superkey,           }, "z",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),
    awful.key({ superkey,           }, "x",
        function ()
            awful.tag.history.restore()
        end,
        {description = "go back", group = "tag"}),

    -- Spawn terminal
    awful.key({ superkey }, "Return", function () awful.spawn(user.terminal) end,
        {description = "open a terminal", group = "launcher"}),
    -- Spawn floating terminal
    awful.key({ superkey, shiftkey }, "Return", function()
        awful.spawn(user.floating_terminal, {floating = true})
    end,
    {description = "spawn floating terminal", group = "launcher"}),

    -- Reload Awesome
    awful.key({ superkey, ctrlkey }, "r", awesome.restart,
        {description = "reload awesome", group = "awesome"}),

    -- Quit Awesome
    -- Logout, Shutdown, Restart, Suspend, Lock
    awful.key({ superkey, shiftkey }, "x",
        function ()
            exit_screen_show()
        end,
        {description = "quit awesome", group = "awesome"}),
    awful.key({ superkey }, "Escape",
        function ()
            exit_screen_show()
        end,
        {description = "quit awesome", group = "awesome"}),

    -- Number of master clients
    awful.key({ superkey, altkey }, "h",
        function ()
            awful.tag.incnmaster( 1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}),
    awful.key({ superkey, altkey }, "l",
        function ()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ superkey, altkey }, "Left",
        function ()
            awful.tag.incnmaster( 1, nil, true)
        end,
        {description = "increase the number of master clients", group = "layout"}),
    awful.key({ superkey, altkey }, "Right",
        function ()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {description = "decrease the number of master clients", group = "layout"}),

    -- Number of columns
    awful.key({ superkey, altkey }, "k",
        function ()
            awful.tag.incncol( 1, nil, true)
        end,
        {description = "increase the number of columns", group = "layout"}),
    awful.key({ superkey, altkey }, "j",
        function ()
            awful.tag.incncol( -1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}),
    awful.key({ superkey, altkey }, "Up",
        function ()
            awful.tag.incncol( 1, nil, true)
        end,
        {description = "increase the number of columns", group = "layout"}),
    awful.key({ superkey, altkey }, "Down",
        function ()
            awful.tag.incncol( -1, nil, true)
        end,
        {description = "decrease the number of columns", group = "layout"}),


    --awful.key({ superkey,           }, "space", function () awful.layout.inc( 1)                end,
    --{description = "select next", group = "layout"}),
    --awful.key({ superkey, shiftkey   }, "space", function () awful.layout.inc(-1)                end,
    --{description = "select previous", group = "layout"}),

    awful.key({ superkey, ctrlkey }, "n",
        function ()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        {description = "restore minimized", group = "client"}),

    -- Prompt
    --awful.key({ superkey },            "d",     function () awful.screen.focused().mypromptbox:run() end,
    --{description = "run prompt", group = "launcher"}),

    -- Run program (d for dmenu ;)
    awful.key({ superkey }, "d",
        function()
            awful.spawn.with_shell("dmenu_run")
        end,
        {description = "rofi launcher", group = "launcher"}),

    -- Dismiss notifications
    awful.key( { ctrlkey }, "space", function()
        naughty.destroy_all_notifications()
                                     end,
        {description = "dismiss notification", group = "notifications"}),

    -- Menubar
    awful.key({ superkey }, "p", function() awful.spawn.with_shell("rofi -matching fuzzy -show combi") end, {description = "show the menubar", group = "launcher"}),

-- Standard program
        awful.key({ superkey, "Control" }, "+",      function (c) awful.util.spawn_with_shell("wget -qO- http://192.168.178.74/on &> /dev/null") end),
        awful.key({ superkey, "Control" }, "-",      function (c) awful.util.spawn_with_shell("wget -qO- http://192.168.178.74/off &> /dev/null") end),
        awful.key({ superkey,           }, "F1",     function (c) awful.util.spawn(user.browser) end),
        awful.key({ superkey,           }, "F2",     function (c) awful.util.spawn("phpstorm") end),
        awful.key({ superkey,           }, "F3",     function (c) awful.util.spawn("gedit") end),
        awful.key({ superkey,           }, "F4",     function (c) awful.util.spawn("thunderbird") end),
        awful.key({ superkey,           }, "F5",     function (c) awful.util.spawn("nautilus") end),
        awful.key({ superkey,           }, "F7",     function (c) awful.util.spawn("spotify") end),
        awful.key({ superkey,           }, "F10",    function (c) awful.util.spawn("gnome-control-center") end),
        awful.key({ superkey,           }, "F11",    function (c) awful.util.spawn("nvidia-settings") end),
        awful.key({ superkey,           }, "F12",    function (c) awful.util.spawn("randrset") end),
        awful.key({ superkey, "Control" }, "F12",    function (c) awful.util.spawn("xrandr --output DP-4 --auto") end),
        awful.key({ superkey, "Shift"   }, "F12",    function (c) awful.util.spawn("xrandr --output DP-4 --off") end),
        awful.key({                   }, "Print",  function (c) awful.util.spawn_with_shell("sleep 0.5 && scrot ~/Screenshots/%y-%b-%d_%H-%M-%S.png") end),
        awful.key({ "Shift",          }, "Print",  function (c) awful.util.spawn_with_shell("sleep 0.5 && scrot ~/Screenshots/%y-%b-%d_%H-%M-%S.png -s") end),
        awful.key({ "Control",        }, "Print",  function (c) awful.util.spawn_with_shell("sleep 0.5 && scrot ~/Screenshots/%y-%b-%d_%H-%M-%S.png -u") end),
-- awful.key({ superkey }, "b", function () for s = 1, screen.count() do mywibox[s].visible = not mywibox[s].visible end end),
        awful.key({                   }, "XF86Calculator", function (c) awful.util.spawn("gnome-calculator") end),
        awful.key({                   }, "XF86Mail",     function (c) awful.util.spawn("thunderbird") end),

    -- Brightness
    awful.key( { }, "XF86MonBrightnessDown",
        function()
            awful.spawn.with_shell("light -U 10")
        end,
        {description = "decrease brightness", group = "brightness"}),
    awful.key( { }, "XF86MonBrightnessUp",
        function()
            awful.spawn.with_shell("light -A 10")
        end,
        {description = "increase brightness", group = "brightness"}),

    -- Volume Control with volume keys
    awful.key( { }, "XF86AudioMute",
        function()
            helpers.volume_control(0)
        end,
        {description = "(un)mute volume", group = "volume"}),
    awful.key( { }, "XF86AudioLowerVolume",
        function()
            helpers.volume_control(-1)
        end,
        {description = "lower volume", group = "volume"}),
    awful.key( { }, "XF86AudioRaiseVolume",
        function()
            helpers.volume_control(1)
        end,
        {description = "raise volume", group = "volume"}),

    -- Volume Control with alt+F1/F2/F3
    awful.key( { altkey }, "F1",
        function()
            helpers.volume_control(0)
        end,
        {description = "(un)mute volume", group = "volume"}),
    awful.key( { altkey }, "F2",
        function()
            helpers.volume_control(-1)
        end,
        {description = "lower volume", group = "volume"}),
    awful.key( { altkey }, "F3",
        function()
            helpers.volume_control(1)
        end,
        {description = "raise volume", group = "volume"}),


    -- Classic Alt+F4 behavior
    --awful.key({ superkey }, "q",      function (c) c:kill() end,
    --    {description = "close", group = "client"}),

    -- Microphone (V for voice)
    awful.key( { superkey }, "v",
        function()
            awful.spawn.with_shell("amixer -D pulse sset Capture toggle &> /dev/null")
        end,
        {description = "(un)mute microphone", group = "volume"}),

    -- Screenshots
    awful.key( { }, "Print", function() helpers.screenshot("full") end,
        {description = "take full screenshot", group = "screenshots"}),
    awful.key( { superkey, ctrlkey }, "s", function() helpers.screenshot("selection") end,
        {description = "select area to capture", group = "screenshots"}),
    awful.key( { superkey, shiftkey }, "s", function() helpers.screenshot("clipboard") end,
        {description = "select area to copy to clipboard", group = "screenshots"}),
    awful.key( { superkey }, "Print", function() helpers.screenshot("browse") end,
        {description = "browse screenshots", group = "screenshots"}),
    awful.key( { superkey, shiftkey }, "Print", function() helpers.screenshot("gimp") end,
        {description = "edit most recent screenshot with gimp", group = "screenshots"}),

    -- Toggle tray visibility
    awful.key({ superkey }, "=",
        function ()
            toggle_tray()
        end,
        {description = "toggle tray visibility", group = "awesome"}),

    -- Media
    awful.key({ superkey }, "period", function() awful.spawn.with_shell("mpc -q next") end,
        {description = "next song", group = "media"}),
    awful.key({ superkey }, "comma", function() awful.spawn.with_shell("mpc -q prev") end,
        {description = "previous song", group = "media"}),
    awful.key({ superkey }, "space", function() helpers.change_language() end,
        {description = "keyboard setting", group = "keyboard"}),
    awful.key({ superkey, shiftkey }, "period", function() awful.spawn.with_shell("mpvc next") end,
        {description = "mpv next song", group = "media"}),
    -- awful.key({ superkey, shiftkey }, "comma", function() awful.spawn.with_shell("mpvc prev") end,
    --     {description = "mpv previous song", group = "media"}),
    -- awful.key({ superkey, shiftkey}, "space", function() awful.spawn.with_shell("mpvc toggle") end,
    --     {description = "mpv toggle pause/play", group = "media"}),
    awful.key({ superkey }, "F8", function() awful.spawn.with_shell("mpvc quit") end,
        {description = "mpv quit", group = "media"}),

    awful.key({ superkey }, "F7", function() awful.spawn.with_shell("freeze firefox") end,
        {description = "send STOP signal to all firefox processes", group = "other"}),
    awful.key({ superkey, shiftkey }, "F7", function() awful.spawn.with_shell("freeze -u firefox") end,
        {description = "send CONT signal to all firefox processes", group = "other"}),

    -- Max layout
    -- Single tap: Set max layout
    -- Double tap: Also disable floating for ALL visible clients in the tag
    awful.key({ superkey }, "w",
        function()
        awful.layout.set(awful.layout.suit.max)
        helpers.single_double_tap(
            nil,
            function()
                local clients = awful.screen.focused().clients
                for _, c in pairs(clients) do
                    c.floating = false
                end
            end
        )
        end,
        {description = "set max layout", group = "tag"}),
    -- Tiling
    -- Single tap: Set tiled layout
    -- Double tap: Also disable floating for ALL visible clients in the tag
    awful.key({ superkey }, "s",
        function()
            awful.layout.set(awful.layout.suit.tile)
            helpers.single_double_tap(
                nil,
                function()
                    local clients = awful.screen.focused().clients
                    for _, c in pairs(clients) do
                        c.floating = false
                    end
                end
            )
        end,
        {description = "set tiled layout", group = "tag"}),
    -- Set floating layout
    awful.key({ superkey, shiftkey }, "s", function()
        awful.layout.set(awful.layout.suit.floating)
                                           end,
        {description = "set floating layout", group = "tag"}),

    -- Start screen
    awful.key({ superkey }, "F12", function()
        start_screen_show()
                                  end,
        {description = "start screen", group = "custom"}),

    -- App drawer
    awful.key({ superkey }, "a", function()
        --app_drawer_show()
                                 end,
        {description = "App drawer", group = "custom"}),

    -- Pomodoro timer
    awful.key({ superkey }, "slash", function() awful.spawn.with_shell("pomodoro") end,
        {description = "pomodoro", group = "launcher"}),

    -- Spawn ranger in a terminal
    awful.key({ superkey }, "F2", function() awful.spawn(user.terminal .. " -e ranger") end,
        {description = "ranger", group = "launcher"}),

    -- Run or raise music client (ncmpcpp in a terminal)
    awful.key({ superkey }, "F3",
        function() helpers.run_or_raise({class = "music"}, true, user.music_client) end,
        {description = "music client", group = "launcher"}),

    -- Spawn cava in a terminal
    awful.key({ superkey }, "F4", function() awful.spawn("visualizer") end,
        {description = "cava", group = "launcher"}),

    -- Spawn ncmpcpp in a terminal, with a special visualizer config
    awful.key({ superkey, shiftkey }, "F4", function() awful.spawn(user.terminal .. " -e 'ncmpcpp -c ~/.config/ncmpcpp/config_visualizer -s visualizer'") end,
        {description = "ncmpcpp", group = "launcher"}),

    -- Network dialog: nmapplet rofi frontend
    awful.key({ superkey }, "F11", function() awful.spawn("networks-rofi") end,
        {description = "spawn network dialog", group = "launcher"}),
    -- Toggle sidebar
    awful.key({ superkey }, "grave", function() sidebar.visible = not sidebar.visible end,
        {description = "show or hide sidebar", group = "awesome"}),
    -- Toggle wibar(s)
    awful.key({ superkey, shiftkey }, "b",
        function()
            toggle_wibars()
        end,
        {description = "show or hide wibar(s)", group = "awesome"}),
    -- Run or raise editor
    awful.key({ superkey }, "e",
        function()
            helpers.run_or_raise({class = 'editor'}, false, user.editor)
        end,
        {description = "editor", group = "launcher"}),
    -- Quick edit file
    awful.key({ superkey, shiftkey }, "e",
        function()
            awful.spawn.with_shell("~/scr/Rofi/rofi_edit")
        end,
        {description = "quick edit file", group = "launcher"}),
    -- mpvtube
    awful.key({ superkey }, "y", function() awful.spawn.with_shell("~/scr/Rofi/rofi_mpvtube") end,
        {description = "mpvtube", group = "launcher"}),
    -- mpvtube song
    awful.key({ superkey, shiftkey }, "y", function() awful.spawn.with_shell("~/scr/info/mpv-query.sh") end,
        {description = "show mpv media title", group = "launcher"}),
    -- Spawn file manager
    awful.key({ superkey, shiftkey }, "f", function() awful.spawn(user.file_manager, {floating = true}) end,
        {description = "file manager", group = "launcher"})
    -- Spawn htop in a terminal
    --awful.key({ superkey }, "p",
    --    function()
    --        awful.spawn(user.terminal .. " -e htop")
    --    end,
    --    {description = "htop", group = "launcher"})
)

keys.clientkeys = gears.table.join(
    -- Move to edge or swap by direction
    awful.key({ superkey, shiftkey }, "Down", function (c)
        helpers.move_client_dwim(c, "down")
    end),
    awful.key({ superkey, shiftkey }, "Up", function (c)
        helpers.move_client_dwim(c, "up")
    end),
    awful.key({ superkey, shiftkey }, "Left", function (c)
        helpers.move_client_dwim(c, "left")
    end),
    awful.key({ superkey, shiftkey }, "Right", function (c)
        helpers.move_client_dwim(c, "right")
    end),
    awful.key({ superkey, shiftkey }, "j", function (c)
        helpers.move_client_dwim(c, "down")
    end),
    awful.key({ superkey, shiftkey }, "k", function (c)
        helpers.move_client_dwim(c, "up")
    end),
    awful.key({ superkey, shiftkey }, "h", function (c)
        helpers.move_client_dwim(c, "left")
    end),
    awful.key({ superkey, shiftkey }, "l", function (c)
        helpers.move_client_dwim(c, "right")
    end),

    -- Single tap: Center client 
    -- Double tap: Center client + Floating + Resize
    awful.key({ superkey }, "c", function (c)
        awful.placement.centered(c, {honor_workarea = true, honor_padding = true})
        helpers.single_double_tap(
            nil,
            function ()
                helpers.float_and_resize(c, screen_width * 0.65, screen_height * 0.9)
            end
        )
    end),
    
    -- Relative move client
    awful.key({ superkey, shiftkey, ctrlkey }, "j", function (c)
        c:relative_move(0,  dpi(20), 0, 0)
    end),
    awful.key({ superkey, shiftkey, ctrlkey }, "k", function (c)
        c:relative_move(0, dpi(-20), 0, 0)
    end),
    awful.key({ superkey, shiftkey, ctrlkey }, "h", function (c)
        c:relative_move(dpi(-20), 0, 0, 0)
    end),
    awful.key({ superkey, shiftkey, ctrlkey }, "l", function (c)
        c:relative_move(dpi( 20), 0, 0, 0)
    end),
    awful.key({ superkey, shiftkey, ctrlkey }, "Down", function (c)
        c:relative_move(0,  dpi(20), 0, 0)
    end),
    awful.key({ superkey, shiftkey, ctrlkey }, "Up", function (c)
        c:relative_move(0, dpi(-20), 0, 0)
    end),
    awful.key({ superkey, shiftkey, ctrlkey }, "Left", function (c)
        c:relative_move(dpi(-20), 0, 0, 0)
    end),
    awful.key({ superkey, shiftkey, ctrlkey }, "Right", function (c)
        c:relative_move(dpi( 20), 0, 0, 0)
    end),

    -- Toggle titlebars (for focused client only)
    awful.key({ superkey,           }, "t",
        function (c)
            -- Don't toggle if titlebars are used as borders
            if not beautiful.titlebars_imitate_borders then
                decorations.toggle(c)
                -- awful.titlebar.toggle(c)
            end
        end,
        {description = "toggle titlebar", group = "client"}),
    -- Toggle titlebars (for all visible clients in selected tag)
    awful.key({ superkey, shiftkey }, "t",
        function (c)
            --local s = awful.screen.focused()
            local clients = awful.screen.focused().clients
            for _, c in pairs(clients) do
                -- Don't toggle if titlebars are used as borders
                if not beautiful.titlebars_imitate_borders then
                    -- awful.titlebar.toggle(c)
                    decorations.toggle(c)
                end
            end
        end,
        {description = "toggle titlebar", group = "client"}),

    -- Toggle fullscreen
    awful.key({ superkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    -- F for focused view
    awful.key({ superkey, ctrlkey  }, "f",
        function (c)
            helpers.float_and_resize(c, screen_width * 0.7, screen_height * 0.75)
        end,
        {description = "focus mode", group = "client"}),
    -- V for vertical view
    awful.key({ superkey, ctrlkey  }, "v",
        function (c)
            helpers.float_and_resize(c, screen_width * 0.45, screen_height * 0.90)
        end,
        {description = "focus mode", group = "client"}),
    -- T for tiny window
    awful.key({ superkey, ctrlkey  }, "t",
        function (c)
            helpers.float_and_resize(c, screen_width * 0.3, screen_height * 0.35)
        end,
        {description = "tiny mode", group = "client"}),
    -- N for normal size (good for terminals)
    awful.key({ superkey, ctrlkey  }, "n",
        function (c)
            helpers.float_and_resize(c, screen_width * 0.45, screen_height * 0.5)
        end,
        {description = "normal mode", group = "client"}),

    -- Close client
    awful.key({ superkey, shiftkey   }, "q",      function (c) c:kill() end,
        {description = "close", group = "client"}),
    awful.key({ superkey }, "q",      function (c) c:kill() end,
        {description = "close", group = "client"}),

    -- Toggle floating client
    awful.key({ superkey, ctrlkey }, "space",
        function(c)
            local layout_is_floating = (awful.layout.get(mouse.screen) == awful.layout.suit.floating)
            if not layout_is_floating then
                awful.client.floating.toggle()
            end
            c:raise()
        end,
        {description = "toggle floating", group = "client"}),

    -- Set master
    awful.key({ superkey, ctrlkey }, "Return", function (c) c:swap(awful.client.getmaster()) end,
        {description = "move to master", group = "client"}),

    -- Change client opacity
    awful.key({ superkey }, "o",
        awful.client.movetoscreen,
        {description = "switch screen", group = "client"}),

    -- P for pin: keep on top OR sticky
    -- On top
    awful.key({ superkey, shiftkey }, "p", function (c) c.ontop = not c.ontop end,
        {description = "toggle keep on top", group = "client"}),
    -- Sticky
    awful.key({ superkey, ctrlkey }, "p", function (c) c.sticky = not c.sticky end,
        {description = "toggle sticky", group = "client"}),

    -- Minimize
    awful.key({ superkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),

    -- Maximize
    awful.key({ superkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ superkey, ctrlkey }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ superkey, shiftkey   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
local ntags = 10
for i = 1, ntags do
    keys.globalkeys = gears.table.join(keys.globalkeys,
        -- View tag only.
        awful.key({ superkey }, "#" .. i + 9,
            function ()
                -- Tag back and forth
                helpers.tag_back_and_forth(i)

                -- Simple tag view
                -- local tag = mouse.screen.tags[i]
                -- if tag then
                -- tag:view_only()
                -- end
            end,
            {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ superkey, ctrlkey }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {description = "toggle tag #" .. i, group = "tag"}),

        -- Move client to tag.
        awful.key({ superkey, shiftkey }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            {description = "move focused client to tag #"..i, group = "tag"}),

        -- Move all visible clients to tag and focus that tag
        awful.key({ superkey, altkey }, "#" .. i + 9,
            function ()
                local tag = client.focus.screen.tags[i]
                local clients = awful.screen.focused().clients
                if tag then
                    for _, c in pairs(clients) do
                        c:move_to_tag(tag)
                    end
                    tag:view_only()
                end
            end,
            {description = "move all visible clients to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ superkey, ctrlkey, shiftkey }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

-- Mouse buttons on the client (whole window, not just titlebar)
keys.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ superkey }, 1, awful.mouse.client.move),
    awful.button({ superkey }, 2, function (c) c:kill() end),
    awful.button({ superkey }, 3, function(c)
        client.focus = c
        c:raise()
        awful.mouse.client.resize(c)
        -- awful.mouse.resize(c, nil, {jump_to_corner=true})
    end),

    -- Superkey + scrolling = Change client opacity
    awful.button({ superkey }, 4, function(c)
        c.opacity = c.opacity + 0.1
    end),
    awful.button({ superkey }, 5, function(c)
        c.opacity = c.opacity - 0.1
    end)
)

-- Mouse buttons on the tasklist
keys.tasklist_buttons = gears.table.join(
    awful.button({ }, 1,
        function (c)
            if c == client.focus then
                c.minimized = true
            else
                -- Without this, the following
                -- :isvisible() makes no sense
                c.minimized = false
                if not c:isvisible() and c.first_tag then
                    c.first_tag:view_only()
                end
                -- This will also un-minimize
                -- the client, if needed
                client.focus = c
                c:raise()
            end
    end),
    -- Middle mouse button closes the window
    awful.button({ }, 2, function (c) c:kill() end),
    awful.button({ }, 3, function (c) c.minimized = true end),
    awful.button({ }, 4, function ()
        awful.client.focus.byidx(-1)
    end),
    awful.button({ }, 5, function ()
        awful.client.focus.byidx(1)
    end),

    -- Side button up - toggle floating
    awful.button({ }, 9, function(c)
        -- c:raise()
        c.floating = not c.floating
    end),
    -- Side button down - toggle ontop
    awful.button({ }, 8, function()
        -- c:raise()
        c.ontop = not c.ontop
    end)
)

-- Mouse buttons on a tag of the taglist widget
keys.taglist_buttons = gears.table.join(
    awful.button({ }, 1, function(t)
        t:view_only()
    end),
    awful.button({ superkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    -- awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ }, 3, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ superkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewprev(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewnext(t.screen) end)
)

-- }}}

-- Set keys
root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)

return keys
