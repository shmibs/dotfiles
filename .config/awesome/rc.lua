-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
-- Vicious widget library
local vicious = require("vicious")
-- lain layouts n stuff
local lain = require("lain")

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
beautiful.init("/home/shmibs/.config/awesome/themes/current/theme.lua")

-- This is used later as the default terminal and editor to run. 
terminal = "mate-terminal" editor = "vim " 

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.max,
    lain.layout.uselessfair,
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, false)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5 }, s, layouts[1])
end
-- }}}

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(" %a %b %d, %H:%M:%S ",1)

-- Create two wiboxen for each screen and add them
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 5, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 4, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
						  -- disable minimisation
                                                  --~ c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     -- right click closes
                     awful.button({ }, 3, function (c)
											  c:kill()
                                              --~ if instance then
                                                  --~ instance:hide()
                                                  --~ instance = nil
                                              --~ else
                                                  --~ instance = awful.menu.clients({ width=250 })
                                              --~ end
                                              
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

mywibox2 = {}
myssid = "N/A"

-- Kernel
oswidget = wibox.widget.textbox()
vicious.register(oswidget, vicious.widgets.os, " $2", 600)
-- top process
procwidget = wibox.widget.textbox()
proctimer = timer{ timeout = 0 }
proctimer:connect_signal("timeout", function()
	proctimer:stop()
	procwidget:set_text(" | " .. awful.util.pread("ps -e --no-header --sort -%cpu -o comm | head -1"))
	proctimer.timeout = 6
	proctimer:start()
end)
proctimer:start()
-- CPU TEMP
ctempwidget = wibox.widget.textbox()
vicious.register(ctempwidget, vicious.widgets.thermal, " CPU ($1° ", 4, "thermal_zone2")
-- CPU
cpuwidget = wibox.widget.textbox()
vicious.register(cpuwidget, vicious.widgets.cpu, "$2% $3% $4% $5%) |", 4)
-- RAM
memwidget = wibox.widget.textbox()
vicious.register(memwidget, vicious.widgets.mem, " RAM ($2 MB / $3 MB) | Swap ($6 MB / $7 MB)", 10)
-- ssid
wifiwidget = wibox.widget.textbox()
vicious.register(wifiwidget, vicious.widgets.wifi, 
	function (widget, args)
		myssid = args["{ssid}"]
		return '(' .. args["{ssid}"] .. ') '
	end,
	3, "wlp7s0")
-- speed ↑ ↓
netwidget = wibox.widget.textbox()
vicious.register(netwidget, vicious.widgets.net,
	function (widget, args)
		--local down = tonumber(args["{enp3s0 down_kb}"]) + tonumber(args["{wpl7s0 down_kb}"])
		--local up = tonumber(args["{enp3s0 up_kb}"]) + tonumber(args["{wpl7s0 up_kb}"])

		if myssid == "N/A" then
			return '[ ↓' .. args["{enp3s0 down_kb}"] .. 'KiB, ↑' .. args["{enp3s0 up_kb}"] .. 'KiB ] '
		else
			return '(' .. myssid .. ') [ ↓' .. args["{wlp7s0 down_kb}"] .. 'KiB, ↑' .. args["{wlp7s0 up_kb}"] .. 'KiB ] '
		end
	end
	)

--~ -- Weather
--~ weatherwidget = wibox.widget.textbox()
--~ vicious.register(weatherwidget, vicious.widgets.weather, "$1")

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s, class = "Wibox" })
    if s == 1 then mywibox2 = awful.wibox({position = "bottom", screen = 1, class = "Wibox" }) end

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    local left_layout2 = wibox.layout.fixed.horizontal()
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    if s == 1 then
		left_layout2:add(oswidget)
		left_layout2:add(procwidget)
	end

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    local right_layout2 = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    right_layout:add(mylayoutbox[s])
	if s == 1 then
		--~ right_layout2:add(wifiwidget)
		right_layout2:add(netwidget)
	end
	
	-- Widgets that are aligned to the bottom centre
	local middle_layout2 = wibox.layout.fixed.horizontal()
	if s == 1 then
		middle_layout2:add(ctempwidget)
		middle_layout2:add(cpuwidget)
		middle_layout2:add(memwidget)
	end

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    local layout2 = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)
    if s == 1 then 
		layout2:set_left(left_layout2) 
		layout2:set_middle(middle_layout2)
		layout2:set_right(right_layout2)
	end

    mywibox[s]:set_widget(layout)
    if s == 1 then mywibox2:set_widget(layout2) end
end
-- }}}

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 5, awful.tag.viewnext),
    awful.button({ }, 4, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "a",
        function ()
            awful.client.focus.byidx(-1)
			if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "d",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),

    --~ awful.key({ modkey,           }, "Tab",
        --~ function ()
            --~ awful.client.focus.history.previous()
            --~ if client.focus then
                --~ client.focus:raise()
            --~ end
        --~ end),
	
	-- power button
	awful.key({                   }, "XF86PowerOff", function () awful.util.spawn_with_shell("mate-session-save --shutdown-dialog") end),
		
	-- banshee commands
    awful.key({ modkey,  "Shift"  }, "Up",     function () awful.util.spawn_with_shell("banshee --show") end),
    awful.key({ modkey,  "Shift"  }, "Down",   function () awful.util.spawn_with_shell("banshee --hide") end),
    awful.key({ modkey,           }, "Left",   function () awful.util.spawn_with_shell("banshee --restart-or-previous") end),
    awful.key({ modkey,           }, "Right",  function () awful.util.spawn_with_shell("banshee --next") end),
    awful.key({ modkey,           }, "Down",   function () awful.util.spawn_with_shell("banshee --toggle-playing") end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn_with_shell(terminal) end),
    awful.key({ modkey,  "Shift"  }, "f",      function () awful.util.spawn_with_shell("firefox") end),
    awful.key({ modkey,  "Shift"  }, "d",      function () awful.util.spawn_with_shell("/home/shmibs/games/desura/desura") end),
    awful.key({ modkey,  "Shift"  }, "o",      function () awful.util.spawn_with_shell("/home/shmibs/stuffs/tor/start-tor-browser") end),
    awful.key({ modkey,  "Shift"  }, "i",      function () awful.util.spawn_with_shell("gimp") end),
    awful.key({ modkey,  "Shift"  }, "w",      function () awful.util.spawn_with_shell("mathematica") end),
    awful.key({ modkey,  "Shift"  }, "c",      function () awful.util.spawn_with_shell("mate-calc") end),
    awful.key({ modkey,  "Shift"  }, "l",      function () awful.util.spawn_with_shell("liferea") end),
    awful.key({ modkey,  "Shift"  }, "v",      function () awful.util.spawn_with_shell("mate-terminal -e \"vim\"") end),
    awful.key({ modkey,  "Shift"  }, "x",      function () awful.util.spawn_with_shell("mcomix") end),
    awful.key({ modkey,  "Shift"  }, "s",      function () awful.util.spawn_with_shell("pavucontrol") end),
    awful.key({ modkey,  "Shift"  }, "t",      function () awful.util.spawn_with_shell("transmission-gtk") end),
    awful.key({ modkey,           }, "#19",    function () awful.util.spawn_with_shell("dmenu_run -fn \"TI Calc Fonts Clean-8\" -h 16 -nb \"" .. beautiful.bg_normal .. "\" -nf \"" .. beautiful.fg_normal .. "\" -sb \"" .. beautiful.bg_focus .. "\" -sf \"" .. beautiful.fg_focus .. "\"") end),
    awful.key({                   }, "Print",  function () awful.util.spawn_with_shell("mate-screenshot") end),
    
	-- bindings for quick access to folders
    awful.key({modkey, "Shift", "Control" }, "Return" , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs\"") end),
    awful.key({modkey, "Shift", "Control" }, "d"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/downloads\"") end),
    awful.key({modkey, "Shift", "Control" }, "s"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/desktop\"") end),
    awful.key({modkey, "Shift", "Control" }, "m"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/music\"") end),
    awful.key({modkey, "Shift", "Control" }, "g"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/games\"") end),
    awful.key({modkey, "Shift", "Control" }, "p"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/projects\"") end),
    awful.key({modkey, "Shift", "Control" }, "r"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/romz\"") end),
    awful.key({modkey, "Shift", "Control" }, "c"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/comics\"") end),
    awful.key({modkey, "Shift", "Control" }, "k"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/disks\"") end),
    awful.key({modkey, "Shift", "Control" }, "i"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/images\"") end),
    awful.key({modkey, "Shift", "Control" }, "b"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/backdrops\"") end),
    awful.key({modkey, "Shift", "Control" }, "t"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/thcool\"") end),
    awful.key({modkey, "Shift", "Control" }, "v"      , function () awful.util.spawn_with_shell(terminal .. " -t ranger -e \"ranger /home/shmibs/videos\"") end),

    -- focus and swap by direction.
    awful.key({ modkey,           }, "k",       function () 	awful.client.focus.bydirection( "up" )
												    if client.focus then client.focus:raise() end
												end),
    awful.key({ modkey,           }, "j",       function () 	awful.client.focus.bydirection( "down" ) 
												    if client.focus then client.focus:raise() end
												end),
    awful.key({ modkey,           }, "h",       function () 	awful.client.focus.bydirection( "left" ) 
												    if client.focus then client.focus:raise() end
												end),
    awful.key({ modkey,           }, "l",       function () 	awful.client.focus.bydirection( "right" ) 
												    if client.focus then client.focus:raise() end
												end),
    awful.key({ modkey, "Control" }, "k",       function () 	awful.client.swap.bydirection( "up" ) end),
    awful.key({ modkey, "Control" }, "j",       function () 	awful.client.swap.bydirection( "down" ) end),
    awful.key({ modkey, "Control" }, "h",       function () 	awful.client.swap.bydirection( "left" ) end),
    awful.key({ modkey, "Control" }, "l",       function () 	awful.client.swap.bydirection( "right" ) end),

	-- switch between screens
	awful.key({ modkey,           }, "s", function()
													awful.screen.focus_relative(1)
												end),
    
    -- switch between window layouts
    awful.key({ modkey,           }, "space", 	function () 
													awful.layout.inc(layouts,  1)
												end),
    awful.key({ modkey,  "Shift"  }, "space", 	function () 
													awful.layout.inc(layouts,  -1)
												end),
    -- restart
    awful.key({ modkey, "Control" }, "r", awesome.restart)
)

clientkeys = awful.util.table.join(
	-- rotate the screen of the current client
	awful.key({ modkey,  "Control"  }, "s",
		function(c)
			awful.screen.focus_relative(1)
			awful.client.movetoscreen(c, mouse.screen)
			awful.client.jumpto(c)
		end),

    awful.key({ modkey,  "Shift"  }, "q",
	    function (c)
			if c.type ~= "dock" and c.type ~= "desktop" then
				c.fullscreen = not c.fullscreen
			end
		end),
    awful.key({ modkey, 			}, "e",
	    function (c)
			if c.type ~= "dock" and c.type ~= "desktop" then
				if c.class ~= "Ftjerm" then
					c:kill()
				end
			end
		end),
	awful.key({ modkey,				}, "t",
		function (c)
			if c.type ~= "dock" and c.type ~= "desktop" then
				c.ontop = not c.ontop
			end
		end),
	awful.key({ modkey,             }, "q",
        function (c)
			if c.type ~= "dock" and c.type ~= "desktop" then
			    if c.maximized_horizontal == true or c.maximized_vertical == true then
					--~ c.border_width = beautiful.border_width
					c.maximized_horizontal = false
					c.maximized_vertical = false
				else
					--~ c.border_width = 0
					c.maximized_horizontal = true
					c.maximized_vertical = true
				end
			end
		end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 5 do
    globalkeys = awful.util.table.join(globalkeys,
	awful.key({ modkey }, "#" .. i + 9,
	function ()
		local screen = mouse.screen
		local tag = awful.tag.gettags(screen)[i]
		if tag then
			awful.tag.viewonly(tag)
		end
	end),
	awful.key({ modkey, "Control" }, "#" .. i + 9,
	function ()
		local tag = awful.tag.gettags(client.focus.screen)[i]
		if client.focus and tag then
			awful.client.movetotag(tag)
		end
	end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) 
		if c.type ~= "dock" and c.type ~= "desktop" then
			client.focus = c;
			c:raise()
		end
	end),
    awful.button({ "Mod1" }, 1, awful.mouse.client.move),
    awful.button({ "Mod1", "Shift" }, 1, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     maximized_horizontal = false,
                     maximized_vertical = false,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { type = "desktop" },
      properties = { border_width = 0,
                     sticky = true,
                     floating = true } },
    { rule = { class = "banshee" },
      properties = { floating = true,
                     maximized_vertical = true,
		     maximized_horizontal = true } },
    { rule_any = { type = { "splash" }, name = { "ftjerm", "GSdx" } },
	  properties = { border_width = 0,
					 floating = true,
					 ontop = true } },
    { rule_any = { type = { "Dialog" }, name = { "plugin-container", "Firefox Preferences", "File Operation Progress" }, class = { "Wine", "M64py", "Pcsx2", "MPlayer", "pinentry", "Gimp", "pavucontrol" } },
      properties = { floating = true } },
    { rule_any = { role = { "gimp-image-window" } },
      properties = { floating = false } }
}
-- }}}

-- {{{ Signals

--~ -- Switch focus to screen upon mouse entry
--~ for s = 1, screen.count() do
	--~ screen[s]:connect_signal("mouse::enter", function(s)
		--~ screen.focus(s)
		--~ client.focus = client.focus.history.get(s)
	--~ end)
--~ end

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
	if c.type == "desktop" then
		c:unmanage()
	else
	    -- Enable sloppy focus
	    --~ c:connect_signal("mouse::enter", function(c)
	        --~ if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
	            --~ and awful.client.focus.filter(c) then
	            --~ client.focus = c
	        --~ end
	    --~ end)
	
	    if not startup then
	        -- Set the windows at the slave,
	        -- i.e. put it at the end of others instead of setting it master.
	        -- awful.client.setslave(c)
	
	        -- Put windows in a smart way, only if they does not set an initial position.
	        if not c.size_hints.user_position and not c.size_hints.program_position then
	            awful.placement.no_overlap(c)
	            awful.placement.no_offscreen(c)
	        end
	    end
	
	    local titlebars_enabled = false
	    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
	        -- buttons for the titlebar
	        local buttons = awful.util.table.join(
	                awful.button({ }, 1, function()
	                    client.focus = c
	                    c:raise()
	                    awful.mouse.client.move(c)
	                end),
	                awful.button({ }, 3, function()
	                    client.focus = c
	                    c:raise()
	                    awful.mouse.client.resize(c)
	                end)
	                )
	
	        -- Widgets that are aligned to the left
	        local left_layout = wibox.layout.fixed.horizontal()
	        left_layout:add(awful.titlebar.widget.iconwidget(c))
	        left_layout:buttons(buttons)
	
	        -- Widgets that are aligned to the right
	        local right_layout = wibox.layout.fixed.horizontal()
	        right_layout:add(awful.titlebar.widget.floatingbutton(c))
	        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
	        right_layout:add(awful.titlebar.widget.stickybutton(c))
	        right_layout:add(awful.titlebar.widget.ontopbutton(c))
	        right_layout:add(awful.titlebar.widget.closebutton(c))
	
	        -- The title goes in the middle
	        local middle_layout = wibox.layout.flex.horizontal()
	        local title = awful.titlebar.widget.titlewidget(c)
	        title:set_align("center")
	        middle_layout:add(title)
	        middle_layout:buttons(buttons)
	
	        -- Now bring it all together
	        local layout = wibox.layout.align.horizontal()
	        layout:set_left(left_layout)
	        layout:set_right(right_layout)
	        layout:set_middle(middle_layout)
	
	        awful.titlebar(c):set_widget(layout)
	    end
	end
end)

client.connect_signal("focus", function(c)
	c:raise()
	c.border_color = beautiful.border_focus 
	c.opacity = 1.0
end)
client.connect_signal("unfocus", function(c)
	c.border_color = beautiful.border_normal
	-- Uncomment to make unfocused terminals transparent when not in "max" mode
	--if awful.layout.getname(awful.layout.get(mouse.screen)) ~= "max" then
	--	if c.class == "Mate-terminal" then
	--		c.opacity = 0.8
	--	end
	--end
end)
-- }}}
