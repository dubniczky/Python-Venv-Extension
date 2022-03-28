#!/bin/bash

# Root warning
if [ "$(id -u)" -eq 0 ]; then
    echo "Warning: Installing to root. This is not a problem, but you will only be able to run venv from the root user or by using sudo."
fi

# Create folder in current user home
mkdir ~/.venvconfig

# Copy files
cp ./.env ~/.venvconfig/.env
cp ./venv.sh ~/.venvconfig/venv.sh

# Make script runnable
chmod +x ~/.venvconfig/venv.sh

# Install into .bashrc
if grep -q "source ~/.venvconfig/venv.sh" ~/.bashrc; then
    echo "Script already installed into bashrc."
    exit
fi

cp ~/.bashrc ~/.bashrc.bkp
sudo cat >> ~/.bashrc << EOF!

# Python venv loading script
source ~/.venvconfig/venv.sh
EOF!

echo "Script installed."
