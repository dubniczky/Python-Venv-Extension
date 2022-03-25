# Root warning
if [ "$(id -u)" -eq 0 ]; then
    echo "Info: Do not use root, unless you want to use the script with the root user."
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