#dotfiles


##Screenshots
[![clean](https://shmibbles.me/img/scrot/current/clean_small.png)](https://shmibbles.me/img/scrot/current/clean.png) [![dirty](https://shmibbles.me/img/scrot/current/dirty_small.png)](https://shmibbles.me/img/scrot/current/dirty.png)

##Structure

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

##Current Utilities

###MATE

i'm using mate-session as a backend to handle dconf garbage / themes / etc for
the few things that expect them. all higher-level mate utilities (wm, file
manager, panel, whatever else) are not installed.

###herbstluftwm

herbstluftwm has the really interesting concept of allowing manual tiling of
frames and then providing automatic layouts for inside those frames. in theory,
it's the best of both worlds, but it gets kind of confusing, so i've just set
the layout to always be max. this way frames basically just have multiple tabs
for me that can by cycled through. it's really neat for saving screen space!
(try splitting a screen with both an editor and a terminal on one side and all
your documentation on the other). i3 can do much the same thing, but it comes
with lots of slightly annoying things to get rid of.

###urxvt

check out
[urxvt-perls](https://github.com/muennich/urxvt-perls).

###ranger/sxiv

both are fantastic for keyboard-driven file management, but still've got to
figure out how to write a ranger extension that can receive selections from
sxiv, because squinting at filenames is just bleh. python is my bane, though...

###pentadactyl

keyboard-driven browsing ^_^. try
[setting your hint keys](http://5digits.org/pentadactyl/faq#faq-hintkeys).

kind of scared of it disappearing forever, though, which will probably happen
after this firefox version is dropped from lts... X_X

###dunst/dmenu/compton/lemonbar/nitrogen

useful things all around. i forked dunst to make SIGUSR1 clear all
notifications, which is used by
[mpc-status.sh](.config/herbstluftwm/mpc-status.sh)
and probably any other similar things i add in the future. not sure what the
default behaviour (pause / unpause notification display) was supposed to be
used for ┐(¯-¯)┌.

oh, also, vector fonts now ^_^.
