#!/bin/bash

# Give XFCE 2 seconds to load the desktop, then find the active monitor and load the wallpaper
(sleep 2 && for p in $(xfconf-query -c xfce4-desktop -l | grep last-image); do xfconf-query -c xfce4-desktop -p $p -s /usr/share/backgrounds/cputwallpaper.png; done) &

# Start the desktop environment
startxfce4
