#!/bin/bash

# Moving Shell command to different files to use them as modules

# Basic Design 
# - Create a log file where all the install outputs store and only a simplified output is seen
# - Be bit more defensive to errors
# - Complete by this month as i have lot to do 

# Few Predefined stuff
NOT="[\e[1;36mNOTE\e[0m]"
OK="[\e[1;32mOK\e[0m]"
ERR="[\e[1;31mERROR\e[0m]"
ATT="[\e[1;37mATTENTION\e[0m]"
WARN="[\e[1;35mWARNING\e[0m]"
ACT="[\e[1;33mACTION\e[0m]"
LOGIT="install.log"

# Custom Functions
if_dir_exists() {
    local dir_path="$1"

    if [ -d "$dir_path" ]; then
        :  # Directory exists
    else
        mkdir "$dir_path"  # Directory does not exist
    fi
} 

echo "Installing i3, rofi, feh, neofetch.........."
sudo pacman -S xorg-server xorg-apps neofetch i3-wm rofi rofi-emoji feh alacritty picom starship paru dunst git pavucontrol pcmanfm python-pywal ttf-jetbrains-mono-nerd noto-fonts materia-gtk-theme gtk-engines gtk-engine-murrine lxappearance
paru -S i3lock-fancy catppuccin-gtk-theme-mocha

# Source the updated .bashrc

cat << EOL >> $HOME/.bashrc
# Source modular configurations
for file in ~/.bashrc.d/*.sh; do
    [ -r "$file" ] && source "$file"
done
EOL

source "$HOME/.bashrc"
        
echo "Moving config files......"