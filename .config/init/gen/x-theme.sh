{
echo "\
! Use the specified colour as the windows background colour [default White]; option -bg.
URxvt*background: $bg_normal

! Use the specified colour as the windows foreground colour [default Black]; option -fg.
URxvt*foreground: $fg_normal

! black
URxvt*color0: $std_black
! light black
URxvt*color8: $light_black
! red
URxvt*color1: $std_red
! light red
URxvt*color9: $light_red
! green
URxvt*color2: $std_green
! light green
URxvt*color10: $light_green
! yellow
URxvt*color3: $std_yellow
! light yellow
URxvt*color11: $light_yellow
! blue
URxvt*color4: $std_blue
! light blue
URxvt*color12: $light_blue
! magenta
URxvt*color5: $std_magenta
! light magenta
URxvt*color13: $light_magenta
! cyan
URxvt*color6: $std_cyan
! light cyan
URxvt*color14: $light_cyan
! white
URxvt*color7: $std_white
! light white
URxvt*color15: $light_white

Sxiv.background: $bg_normal
Sxiv.foreground: $fg_focus
Sxiv.select: $bg_focus
Sxiv.bar: $bg_focus
"

# Select the fonts to be used. This is a comma separated list of font names that are checked in order when trying to find glyphs for characters. The first font
echo -n "URxvt*font: "
echo -n "xft:${mfont}:size=${mfont_size}, "
echo -n "xft:${jfont}:size=${jfont_size}, "
echo -n "xft:${cfont}:size=${cfont_size}, "
echo -n "xft:${efont}:size=${efont_size}, "
echo -n "xft:${tfont}:size=${tfont_size}, "
echo    "xft:${bkfont}:size=${bkfont_size}"

[[ -n $urxvt_bg ]] && echo "URxvt*backgroundPixmap: $HOME/backdrops/urxvt/$urxvt_bg"

echo -n "Sxiv.font: xft:${mfont}:size=${mfont_size}"

} > /tmp/x-theme

