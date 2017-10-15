# dotfiles

## Screenshots

[![clean](https://shmibbles.me/img/scrot/current/clean_small.png)](https://shmibbles.me/img/scrot/current/clean.png) [![dirty](https://shmibbles.me/img/scrot/current/dirty_small.png)](https://shmibbles.me/img/scrot/current/dirty.png)

## Structure

[.config/init/](.config/init) contains [vars](.config/init/vars), a file
defining shared variables for the desktop which are sourced and used elsewhere,
and a series of "gen/*.sh" files, which create configuration files in /tmp/ so
programs not configurable via shell scripting will automatically match the
current settings as well. i stick symlinks to the /tmp/ version where they
would normally be. also included are folders "funcs" and "funcreqs", which,
respectively, contain executable scripts and their prerequisite commands and
arbitrary check commands. the latter prerequisites are tested from .zprofile at
login and, if passed, the functions are symlinked into /tmp/funcs, which is
included in $PATH. thus, this system allows for configs which automatically
adapt to the host environment, enabling only what functionality is compatible.

## Current Utilities

### herbstluftwm

herbstluftwm has the really interesting concept of allowing manual tiling of
frames and then providing automatic layouts for inside those frames. in theory,
it's the best of both worlds, but it gets kind of confusing, so i've just set
the layout to always be max. this way frames basically just have multiple tabs
for me that can by cycled through. it's really neat for saving screen space!
(try splitting a screen with both an editor and a terminal on one side and all
your documentation on the other). i3 can do much the same thing, but it comes
with lots of slightly annoying things to get rid of.

### urxvt

has some quirks, but still nothing else out there with the same functionality.
check out [urxvt-perls](https://github.com/muennich/urxvt-perls).

### ranger/sxiv

both are fantastic for keyboard-driven file management, but still've got to
figure out how to write a ranger extension that can receive selections from
sxiv, because squinting at filenames is just bleh. python is my bane, though...

### dunst/dmenu/compton/lemonbar/nitrogen

useful things all around. i forked dunst to make SIGUSR1 clear all
notifications, which is used by
[mpc-status.sh](.config/herbstluftwm/mpc-status.sh) and
[pvol.sh](.config/herbstluftwm/pvol.sh).

### fcitx

input is messy, but fcitx seems like the most functional out there at the
moment. fcitx-mozc a nice.
