#!/bin/bash

echo -e "\e[32m ####   ####### \e[0m"
echo -e "\e[32m ####  ##     ##\e[0m"
echo -e "\e[32m              ##\e[0m"
echo -e "\e[32m  ##    ####### \e[0m"
echo -e "\e[32m  ##          ##\e[0m"
echo -e "\e[32m  ##   ##     ##\e[0m"
echo -e "\e[32m ####   ####### \e[0m"


echo -e "\e[31m!!!!!!!!---------------- Warning -------------!!!!!!!!!\e[0m"
echo -e "\e[31m////// You will be Prompt to enter sudo password,//////\e[0m"
echo -e "\e[31m// Use it at your own risk as it involves installing //\e[0m"
echo -e "\e[31m///// packages and it hasn't been tested properly /////\e[0m"
echo -e "\e[31m-------------------------------------------------------\e[0m"


# Prompt the user for confirmation
read -p "Do you want to run my script? (y/n): " choice

# Check the user's choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "Running the install script..."
else
    echo "Installation canceled."
    exit 1
fi

#step 1 - install the i3 window manager and required packages
distro=$(cat /etc/os-release | awk -F= '/NAME=/ {gsub(/"/, "", $2); print $2; exit}')

case $distro in
    "Arch Linux")
        #i will fill with the dependencies to install i3, polybar, alacrity, rofi , feh, neofetch
        echo "Installing i3, rofi, feh, neofetch.........."
        sudo pacman -s neofetch i3-wm rofi rofi-emoji feh alacritty picom 

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

        ;;
    "Fedora Linux")
        #i will fill with the dependencies to install i3, polybar, alacrity, rofi , feh, neofetch
        ;;
    "Ubuntu" | "Debian"*)
        #Installing i3 rofi feh

        echo "Installing i3, rofi, feh, neofetch.........."
        sudo apt -y install i3 rofi feh 

        #All the git repos and source build is done in this folder
        mkdir build_files

        #installing alacritty dependencies
        sudo apt -y install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3 curl cargo

        #Installing Rust
        sudo curl https://sh.rustup.rs -sSf | sh

        cd build_files

        #cloning alacritty repo
        git clone https://github.com/alacritty/alacritty.git
        cd alacritty

        cargo build --release

        echo "Verifying ............ "

        if infocmp alacritty &> /dev/null; then
            echo "Alacritty is installed"
        else
            echo "Alacritty is not installed correctly."
            sudo tic -xe alacritty,alacritty-direct extra/alacritty.info
        fi

        #adding binaries
        sudo cp target/release/alacritty /usr/local/bin

        #autocompletion
        echo "source $(pwd)/extra/completions/alacritty.bash" >> ~/.bashrc

        cd ..

        #Installing PICOM
        
        echo "Installing Picom........"

        # Dependencies
        sudo apt install libconfig-dev libdbus-1-dev libegl-dev libev-dev libgl-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev libxext-dev meson ninja-build uthash-dev

        git clone https://github.com/yshui/picom.git

        cd picom

        # building picom
        meson setup --buildtype=release build
        ninja -C build

        #installing picom
        ninja -C build install

        cd ..

        #Installing Oh-my-posh
        echo "Installing Oh-my-posh......."

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

        cd ..

        echo "Moving config files......"
 
        ;;
    *)
        echo "Distribution not recognized. This install script is only made for Arch , Fedora and Ubuntu."
        ::
esac

#step 2 - configure the window manager

# Custom Functions
if_dir_exists() {
    local dir_path="$1"

    if [ -d "$dir_path" ]; then
        :  # Directory exists
    else
        mkdir "$dir_path"  # Directory does not exist
    fi
} 