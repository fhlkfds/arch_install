#!/bin/bash

cd ~/

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si


echo "Yay is installed"


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
installed_aur() {
    read -p "Do you want to install missing packages? [y/N] " response
    if [[ "$response" =~ ^[Yy] ]]; then
        yay -S - "$packages"
    else
        echo "Skipping installation"
    fi
}


# install main packages
while read packages; do
    if ! pacman -Q "$packages" >/dev/null 2>&1; then
        echo "Package not installed: $packages"
        missing_packages="$missing_packages $packages"
    fi
done < main_install.txt

if [ -n "$missing_packages" ]; then
    yay -S --needed $missing_packages
fi


# Install aur packages
while read packages; do
    if ! yay -Q "$packages" >/dev/null 2>&1; then
        echo "Package not installed: $packages"
        yay -S - < aur_install.txt
    fi
done < aur_install.txt



pacman -S --needed git base-devel
git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyDE
cd ~/HyDE/Scripts
./install.sh




read -p "Do you want to do GPU passthrough(y/N)"

if [[ "$response" =~ ^[Yy] ]]; then
  git clone https://github.com/HikariKnight/quickpassthrough.git
else
  exit 0
if
