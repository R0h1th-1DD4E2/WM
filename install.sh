#!/bin/bash

#step 1 - install the i3 window manager
distro=$(cat /etc/os-release | awk -F= '/NAME=/ {gsub(/"/, "", $2); print $2; exit}')

case $distro in
    "Arch Linux")
        #i will fill with the dependencies to install i3, polybar, alacrity, rofi , feh, neofetch
        ;;
    "Fedora Linux")
        #i will fill with the dependencies to install i3, polybar, alacrity, rofi , feh, neofetch
        ;;
    "Ubuntu")
        #i will fill with the dependencies to install i3, polybar, alacrity, rofi , feh, neofetch
        ;;
    *)
        echo "Distribution not recognized. Please install dependencies manually."
        ::
esac

#step 2 - configure the window manager