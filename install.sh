#!/bin/bash

echo "!!!!!!!!------ Warning ------!!!!!!!!!"
echo "You will be Prompt to enter sudo password, Use it at your own risk as it involves installing packages and it hasn't been tested properly"
echo "--------------------------------------"

# Prompt the user for confirmation
read -p "Do you want to run my script? (y/n): " choice

# Check the user's choice
if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
    echo "Running the install script..."
else
    echo "Installation canceled."
    exit 1
fi

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
        #Installing i3 rofi feh

        echo "Installing i3 rofi feh .........."
        sudo apt -y install i3 rofi feh 

        #All the git repos and source build is done in this folder
        mkdir build_files

        #installing alacritty dependencies
        sudo apt -y install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3

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
        # I'll fill this later 

        #Installing Oh-my-posh
        curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ./

        mv oh-my-posh 

        ;;
    *)
        echo "Distribution not recognized. Please install dependencies manually."
        ::
esac

#step 2 - configure the window manager

# Custom Functions
if_dir_exists() {
    local dir_path="$1"

    if [ -d "$dir_path" ]; then
        return 0  # Directory exists
    else
        return 1  # Directory does not exist
    fi
} 