#!/bin/bash

NOT="[\e[1;36mNOTE\e[0m]"
OK="[\e[1;32mOK\e[0m]"
ERR="[\e[1;31mERROR\e[0m]"
ATT="[\e[1;37mATTENTION\e[0m]"
WARN="[\e[1;35mWARNING\e[0m]"
ACT="[\e[1;33mACTION\e[0m]"
LOGIT="install.log"

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
        # Arch Script here
        ./scripts/arch.sh

        ;;
    "Fedora Linux")
        # If contributed add it here please
        ;;
    "Ubuntu" | "Debian"*)
        # If contributed add it here please
        ;;
    *)
        echo "$ERR Distribution not supported. This install script is only made for Arch"
        ::
esac

#step 2 - configure the window manager