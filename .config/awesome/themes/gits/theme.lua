-------------------------------
--  "current" current theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://current.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.directory = "/home/shmibs/.config/awesome/themes/current/"
theme.wallpaper = theme.directory .. "backdrop.jpg"

-- }}}

-- {{{ Styles
theme.font      = "TI Calc Fonts Clean 8"

-- {{{ Colors
theme.fg_focus   = "#FCFCFC"
theme.fg_normal  = "#FCFCFC"
theme.fg_urgent  = "#FCFCFC"
theme.bg_focus   = "#7a658f"
theme.bg_normal  = "#333333"
theme.bg_urgent  = "#df3c29"
theme.bg_systray = theme.bg_normal
-- }}}

-- {{{ Borders
theme.border_width  = 2
theme.border_focus  = theme.bg_focus
theme.border_normal = theme.bg_normal
theme.border_marked = theme.bg_urgent
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_normal = "#93A8C2"
theme.titlebar_bg_focus  = "#7F91A7"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.fg_widget        = "#AECF96"
--theme.fg_center_widget = "#88A175"
--theme.fg_end_widget    = "#FF5656"
--theme.bg_widget        = "#494B4F"
--theme.border_widget    = "#3F3F3F"
-- }}}

-- {{{ Mouse finder
theme.mouse_finder_color = "#79412E"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = 15
theme.menu_width  = 108
-- }}}

-- {{{ lain
theme.useless_gap_width = 10
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme.directory .. "taglist/squarefz.png"
theme.taglist_squares_unsel = theme.directory .. "taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = theme.directory .. "awesome-icon.png"
theme.menu_submenu_icon      = theme.directory .. "submenu.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme.directory .. "layouts/tile.png"
theme.layout_tileleft   = theme.directory .. "layouts/tileleft.png"
theme.layout_tilebottom = theme.directory .. "layouts/tilebottom.png"
theme.layout_tiletop    = theme.directory .. "layouts/tiletop.png"
theme.layout_uselesstile= theme.directory .. "layouts/tile.png"
theme.layout_fairv      = theme.directory .. "layouts/fairv.png"
theme.layout_fairh      = theme.directory .. "layouts/fairh.png"
theme.layout_uselessfair= theme.directory .. "layouts/fairv.png"
theme.layout_spiral     = theme.directory .. "layouts/spiral.png"
theme.layout_dwindle    = theme.directory .. "layouts/dwindle.png"
theme.layout_max        = theme.directory .. "layouts/max.png"
theme.layout_fullscreen = theme.directory .. "layouts/fullscreen.png"
theme.layout_magnifier  = theme.directory .. "layouts/magnifier.png"
theme.layout_floating   = theme.directory .. "layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus 				= theme.directory .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal				= theme.directory .. "titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active		= theme.directory .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active		= theme.directory .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive		= theme.directory .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive		= theme.directory .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active		= theme.directory .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active		= theme.directory .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive		= theme.directory .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive	= theme.directory .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active		= theme.directory .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active	= theme.directory .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive	= theme.directory .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive	= theme.directory .. "titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active	= theme.directory .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active	= theme.directory .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive	= theme.directory .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive	= theme.directory .. "titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
