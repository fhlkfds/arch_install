#!/bin/bash

cd ~/

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si


echo "Yay is installed"


sleep 10


cd ~/arch_install

# Define the installation function first
installed() {
    read -p "Do you want to install missing packages? [y/N] " response
    if [[ "$response" =~ ^[Yy] ]]; then
        sudo pacman -S "$packages"
    else
        echo "Skipping installation"
    fi
}

# Then use the while loop
while read packages; do
    if ! pacman -Q "$packages" >/dev/null 2>&1; then
        echo "Package not installed: $packages"
        installed
    fi
done < install.txt

sleep 10

pacman -S --needed git base-devel
git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyDE
cd ~/HyDE/Scripts
./install.sh


sleep 10


read -p "Do you want to do GPU passthrough(y/N)"

if [[ "$response" =~ ^[Yy] ]]; then
  git clone https://github.com/HikariKnight/quickpassthrough.git
else
  exit 0
if
