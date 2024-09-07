#!/bin/bash

GREEN="\033[1;32m"
NC="\033[0m"

DESTINATION="$HOME/.config"
sudo mkdir -p "$DESTINATION"
sudo mkdir -p "$HOME/scripts"

echo -e "${GREEN}---------------------------------------------------"
echo -e "${GREEN}            Installing dependencies"
echo -e "${GREEN}---------------------------------------------------${NC}"

cd "$HOME/Linux-Post-Installation/scripts"

# Make sure that install_packages script is executable
sudo chmod +x install_packages
sudo chmod +x install_nala
./install_packages

echo -e "${GREEN}---------------------------------------------------"
echo -e "${GREEN}       Moving dotfiles to correct location"
echo -e "${GREEN}---------------------------------------------------${NC}"

cd "$HOME/Linux-Post-Installation/dotfiles"

sudo cp -r alacritty "$DESTINATION/"
sudo cp -r backgrounds "$DESTINATION/"
sudo cp -r fastfetch "$DESTINATION/"
sudo cp -r kitty "$DESTINATION/"
sudo cp -r picom "$DESTINATION/"
sudo cp -r rofi "$DESTINATION/"
sudo cp -r suckless "$DESTINATION/"

echo -e "${GREEN}---------------------------------------------------"
echo -e "${GREEN}    Moving Home dir files to correct location"
echo -e "${GREEN}---------------------------------------------------${NC}"

sudo cp .bashrc "$HOME/"
sudo cp -r .local "$HOME/"
sudo cp -r scripts "$HOME/"
sudo cp .xinitrc "$HOME/"

echo -e "${GREEN}---------------------------------------------------"
echo -e "${GREEN}            Fixing Home dir permissions"
echo -e "${GREEN}---------------------------------------------------${NC}"

sudo chown -R "$USER":"$USER" "$HOME/.config"
sudo chown -R "$USER":"$USER" "$HOME/scripts"
sudo chown "$USER":"$USER" "$HOME/.bashrc"
sudo chown -R "$USER":"$USER" "$HOME/.local"
sudo chown "$USER":"$USER" "$HOME/.xinitrc"

echo -e "${GREEN}---------------------------------------------------"
echo -e "${GREEN}                  Fixing Timezone"
echo -e "${GREEN}---------------------------------------------------${NC}"

sudo dpkg-reconfigure tzdata

echo -e "${GREEN}---------------------------------------------------"
echo -e "${GREEN}            Building DWM and SLStatus"
echo -e "${GREEN}---------------------------------------------------${NC}"

LOG_FILE="$HOME/build.log"

sudo -u $USER bash -c "source $HOME/.bashrc && mi" > "$LOG_FILE" 2>&1

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Build completed successfully.${NC}"
else
    echo -e "${RED}Build failed. Check the log file for details: $LOG_FILE${NC}"
fi

echo -e "${GREEN}---------------------------------------------------"
echo -e "${GREEN}     Script finished. Reboot is recommended"
echo -e "${GREEN}---------------------------------------------------${NC}"

echo -e "${GREEN}---------------------------------------------------"
echo -e "${GREEN}    Do you want to restart the system now? (y/n)"
echo -e "${GREEN}---------------------------------------------------${NC}"

read -p "Restart now? [y/n]: " response

if [[ "$response" == "y" || "$response" == "Y" ]]; then
    echo -e "${GREEN}Restarting the system...${NC}"
    sudo reboot
else
    echo -e "${GREEN}Restart skipped. Please remember to restart your system later.${NC}"
fi