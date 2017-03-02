#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# so all binaries are visible in dmenu_run
export PATH="$PATH:$HOME/.i3/bin:$HOME/.bin:$HOME/bin"

# use xresources
xrdb -merge ~/.i3/xresources

# color temperature adjustment, set for Boise
redshift -l 42.56:114.46 -m randr -t 4800:3500 -g 0.75:0.75:0.75 &

# notification
dunst -config ~/.i3/dunstrc &

# terminal server
urxvtd &

xcape

i3

true
