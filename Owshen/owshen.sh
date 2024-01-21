#!/bin/bash

wget -O loader.sh https://raw.githubusercontent.com/DiscoverMyself/Ramanode-Guides/main/loader.sh && chmod +x loader.sh

clear
curl -s https://raw.githubusercontent.com/DiscoverMyself/Ramanode-Guides/main/logo.sh | bash
sleep 2


echo "Updating packages..."
sudo apt update
echo "Installing Node.js and npm..."
sudo apt install nodejs npm -y
echo "Node.js and npm installed."


echo "Installing FUSE..."
sudo apt install libfuse2 -y
sudo modprobe fuse
sudo groupadd fuse 2>/dev/null 
user="$(whoami)"
sudo usermod -a -G fuse "$user"
echo "FUSE installed."


echo "Installing snarkjs..."
sudo npm install -g snarkjs
echo "snarkjs installed."


echo "Downloading Owshen Wallet..."
if [ ! -f Owshen_v0.1.3_x86_64.AppImage ]; then
    wget https://github.com/OwshenNetwork/owshen/releases/download/v0.1.3/Owshen_v0.1.3_x86_64.AppImage
fi
chmod +x Owshen_v0.1.3_x86_64.AppImage
echo "Owshen Wallet downloaded and made executable."


initialize_wallet() {
    read -p "Enter your 12-word mnemonic phrase: " MNEMONIC
    ./Owshen_v0.1.3_x86_64.AppImage init --mnemonic "$MNEMONIC"
}


if [ ! -f ~/.owshen-wallet ]; then
    echo "Initializing Owshen Wallet..."
    initialize_wallet
else
    echo "Owshen Wallet is already initialized."
    read -p "Do you want to reinitialize your wallet? (y/n): " REINIT
    if [[ $REINIT =~ ^[Yy]$ ]]; then
        echo "Removing old wallet files..."
        rm -rf ~/.owshen-wallet
        rm -rf ~/.owshen-wallet-cache
        initialize_wallet
    fi
fi


echo "Running Owshen Wallet..."
./Owshen_v0.1.3_x86_64.AppImage wallet