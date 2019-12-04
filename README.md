# dotfiles

desktop configurations. function over form, though things being pretty is nice

## Screenshots

[![clean](https://airen-no-jikken.icu/img/scrot/current/clean_small.png)](https://airen-no-jikken.icu/img/scrot/current/clean.png) [![dirty](https://airen-no-jikken.icu/img/scrot/current/dirty_small.png)](https://airen-no-jikken.icu/img/scrot/current/dirty.png)

## Structure

[.config/init/](.config/init) contains [vars](.config/init/vars), a file
defining shared variables for the desktop which are sourced and used elsewhere.
these settings can be overridden by creating a "voverride" file in the same
directory. `.config/init` also contains a series of "gen/*.sh" files, which
create configuration files in /tmp/ so programs not configurable via shell
scripting will automatically match the current settings as well. i stick
symlinks to the /tmp/ version where they would normally be. also included are
folders "[funcs](.config/init/funcs/)" and
"[funcreqs](.config/init/funcreqs/)", which, respectively, contain executable
scripts and their prerequisite commands and arbitrary check commands. the
latter prerequisites are tested from [.zprofile](.zprofile) at login and, if
passed, the functions are symlinked into /tmp/funcs, which is appended to
`$PATH`. thus, this system allows for configs which automatically adapt to the
host environment, enabling only what functionality is compatible. so far i've
been the only user on systems using this config, but will probably make the dir
these are written into configurable as well if that ever changes (since
otherwise that's a pretty big security flaw, with anyone who can write to tmp
able to add commands to the shell).

## Current Utilities

### [nvim](https://neovim.io/)/[vim](https://www.vim.org/)

using nvim, but no big incompatibilities with base vim yet with the way i use
it, so falling back works fine. have a few fun things, including auto-loaded,
filetype-specific settings and basic [templates](.vim/skel), a few fancy
mappings, and a simple 16-colour [colourscheme](.vim/colors/shmibs.vim). take a
look at muh [.vimrc](.vimrc) for details and things.

### [herbstluftwm](http://herbstluftwm.org/)

herbstluftwm has the really interesting concept of
allowing manual tiling of frames and then providing automatic layouts for
inside those frames. in theory, it's the best of both worlds, but it gets kind
of confusing, so i've just set the layout to always be max. this way frames
basically just have multiple tabs for me that can by cycled through. it's
really neat for saving screen space! (try splitting a screen with both an
editor and a terminal on one side and all your documentation on the other). i3
can do much the same thing, but it comes with lots of slightly annoying things
to get rid of.

### [urxvt](http://software.schmorp.de/pkg/rxvt-unicode.html)

has some quirks, but still nothing else out there with the same functionality.
check out [urxvt-perls](https://github.com/muennich/urxvt-perls).

### [ranger](https://ranger.github.io/)/[sxiv](https://github.com/muennich/sxiv)

both are fantastic for keyboard-driven file management. i've forked sxiv to use
4 colours rather than 2, to better fit the theme, but still've got to figure
out how to write a ranger extension that can receive selections from sxiv,
because squinting at filenames is just bleh. python is my bane, though...

### [pass](https://www.passwordstore.org/)

a nice password manager-a-ma-bob, gpg locked and easy to sync with git. there's
a firefox addon, but it doesn't really work, and there's an existing dmenu
frontend, but it's not very featureful, so [i wrote my
own](.config/herbstluftwm/pass.sh).

### [dunst](https://github.com/dunst-project/dunst)/[dmenu](https://bitbucket.org/melek/dmenu2)/[picom](https://github.com/yshui/picom)/[lemonbar](https://github.com/krypt-n/bar)/[nitrogen](http://projects.l3ib.org/nitrogen/)

useful things all around. i've "patched" dunst (really just a very bad hack) to
auto clean up on-screen messages when notifications are received from
[mpc-status.sh](.config/herbstluftwm/mpc-status.sh) and
[pvol.sh](.config/herbstluftwm/pvol.sh), which makes things update cleanly
in-place if a key is repeatedly pressed. hopefully this sort of functionality
will be added properly, but the documentation is sparse and don't have the time
to figure out how right now x-x

### [fcitx](http://fcitx-im.org)

input is messy, but fcitx seems like the most functional out there at the
moment. fcitx-mozc a nice.
