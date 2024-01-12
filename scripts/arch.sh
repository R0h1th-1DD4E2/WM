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
        sudo pacman -s neofetch i3-wm rofi rofi-emoji feh alacritty picom starship paru 

        read -p "Do you want to install oh-my-posh? (y/n): " opinion
        if [ "$opinion" = "y" ] || [ "$opinion" = "Y" ]; then
            echo "Installing Oh-my-posh......."
            #Installing Oh-my-posh
        
            curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ./

            if_dir_exists "$HOME/.oh-my-posh"
            if_dir_exists "$HOME/.local/share/oh-my-posh/themes"
            
            cp oh-my-posh $HOME/.oh-my-posh

            source_dir="$HOME/.cache/oh-my-posh/themes"
            destination_dir="$HOME/.local/share/oh-my-posh/themes"

            if [ -d "$source_dir" ]; then
                mv "$source_dir" "$destination_dir"
                echo "Themes moved from $source_dir to $destination_dir"
            else
                echo "Source directory $source_dir not found."
                echo "Try installing oh-my-posh again manually "
            fi

            ohmyposh_path="$HOME/.oh-my-posh"
            ohmyposh_theme_command="eval \"\$(oh-my-posh init bash --config $HOME/.local/share/oh-my-posh/themes/catppuccin_macchiato.omp.json)\""

            # Adding the paths and configurations to .bashrc
            if ! grep -q "export PATH=\"$ohmyposh_path\"" "$HOME/.bashrc"; then
                echo "export PATH=\"$ohmyposh_path\"" >> "$HOME/.bashrc"
            fi

            if ! grep -q "$ohmyposh_theme_command" "$HOME/.bashrc"; then
                echo "$ohmyposh_theme_command" >> "$HOME/.bashrc"
            fi

            # Source the updated .bashrc
            source "$HOME/.bashrc"
        else
            echo "Oh-my=posh was not installed ..."
        fi
        
        echo "Moving config files......"