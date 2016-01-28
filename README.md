#dotfiles


##Screenshots
[![clean](http://shmibbles.me/img/scrot/current/clean_small.png)](http://shmibbles.me/img/scrot/current/clean.png)[![dirty](http://shmibbles.me/img/scrot/current/dirty_small.png)](http://shmibbles.me/img/scrot/current/dirty.png)

##Current Utilities

###MATE

i'm using mate as a backend to handle dconf garbage / themes / etc.

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
sxiv, because squinting at filenames is just bleh.

###pentadactyl

keyboard-driven browsing ^_^. try
[setting your hint keys](http://5digits.org/pentadactyl/faq#faq-hintkeys).

###dunst/dmenu/compton/lemonbar/nitrogen

useful things all around. i forked dunst to make SIGUSR1 clear all
notifications, which is used by
[mpc-status.sh](.config/herbstluftwm/mpc-status.sh)
and probably any other similar things i add in the future. not sure what the
default behaviour (pause / unpause notification display) was supposed to be
used for ┐(¯-¯)┌.
