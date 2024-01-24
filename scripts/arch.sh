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
LOGIT="$HOME/install.log"

# Adding Path as Variables
BASHRC="$HOME/.bashrc.d"
CONFIG="$HOME/.config"
LOCAL="$HOME/.local/share/rofi"
EXEC="$HOME/.exec"
FONT="$HOME/.fonts"
WALL="$HOME/Pictures/wall"
INSTALL_FILE="./install.sh"
TOUCHPAD="/etc/X11/xorg.conf.d/30-touchpad.conf"

# Custom functions here
install() {
  # Hre $1 is the package name and $2 is the package manager 
  # install <package_name> <package_manager>
  if [ "$2" != "pacman" ] && [ "$2" != "paru" ]; then # Check if right package manager is prompted
    echo -e "$ERR - Invalid package manager specified. Please use 'pacman' or 'paru'."
    exit 1
  fi

  if $2 -Q $1 &>> /dev/null ; then  # Check If package exists
    echo -e "$OK - $1 is already installed."
  else
    echo -e "$NOT - Now installing $1 using $2 ..." # If not found then install it
    $2 -S --noconfirm $1 &>> $LOGIT

    if $2 -Q $1 &>> /dev/null ; then
      echo -e "\e[1A\e[K$OK - $1 was installed using $2."  # If install Successfully log the process as clean 
    else # if found error then exit the script 
      echo -e "\e[1A\e[K$ERR - $1 install failed using $2, please check the install.log" 
      exit 1
    fi
  fi
}

mvconfig() {
    local dir_path="$1"
    local config_path="$2"

    if [ -d "$dir_path" ]; then
        echo -e "$NOT - Path $dir_path exists moving files into it" # Directory does exist
    else
        mkdir -p "$dir_path"  # Directory does not exist
    fi

    if [ -d "$dir_path" ]; then
      mv $dir_path "$dir_path.bak" # backup old config files htat exists 
      echo "mvconfig: Backing up existing files to '$dir_path.bak'" &>> $LOGIT
    fi

    cp -rf $config_path $dir_path
    echo "mvconfig: Copying new config from '$config_path' to '$dir_path'" &>> $LOGIT
} 


# -------------------------- Real Script Here -----------------------------

# -------------------------- Stage 1 -----------------------------

echo -e "$NOT - Stage 1 - Installing packages, this may take a while..."

# Install Require Packages 
for SOFTWARE in xorg-server xorg-apps neofetch i3-wm rofi rofi-emoji feh alacritty picom starship paru dunst git pavucontrol pcmanfm python-pywal ttf-jetbrains-mono-nerd materia-gtk-theme gtk-engines gtk-engine-murrine lxappearance
    do
        install $SOFTWARE pacman
done

for SOFTWARE in i3lock-fancy catppuccin-gtk-theme-mocha tela-circle-icon-theme-purple
    do
        install $SOFTWARE paru
done

# Adding my custom bash aliases and other stuff to main .bashrc file
cat <<EOF >> $HOME/.bashrc
# Source custom bash modules
if [ -d "\$HOME/.bashrc.d" ]; then
    for file in \$HOME/.bashrc.d/*.sh; do
        [ -r "\$file" ] && source "\$file"
    done
fi
EOF

# Source the updated .bashrc
source "$HOME/.bashrc"

# -------------------------- Stage 2 -----------------------------

echo "$NOT - Stage 2 - Moving config files..."

if [ -f "$INSTALL_FILE" ]; then
    BASE_DIR="$(pwd)"

    mvconfig $BASHRC "$BASE_DIR/bashrc.d"
    mvconfig $CONFIG "$BASE_DIR/config"
    mvconfig $EXEC "$BASE_DIR/exec"
    mvconfig $FONT "$BASE_DIR/fonts"
    mvconfig $LOCAL "$BASE_DIR/local/share/rofi"
    mvconfig $WALL "$BASE_DIR/files/wall"

    if ![ -f "$TOUCHPAD" ]; then
      sudo cp "$BASE_DIR/files/30-touchpad.conf" /etc/X11/xorg.conf.d/
    fi

    # Update Font Cache
    fc-cache -fv
else
    echo "$ERR - $INSTALL_FILE does not exist in the current directory. Please Run the directory with [\e[1;31mINSTALL SCRIPT\e[0m]."
fi