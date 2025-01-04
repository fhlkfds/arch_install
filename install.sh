#!/bin/bash

cd /opt/

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si


echo "Yay is installed"


sleep 10



installed() { 
  yay -S - ~/auto/package_list.txt
}


while read packages; do
  if ! pacman -Q "$packages" >/dev/null 2>&1;then
    echo "packages are not installed"
    installed()
  fi
done < install.txt

pacman -S --needed git base-devel
git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/auto/HyDE
cd ~/auto/HyDE/Scripts
./install.sh





read -p "Do you want to do GPU passthrough(y/N)"

if [[ "$response" =~ ^[Yy] ]]; then
  git clone https://github.com/HikariKnight/quickpassthrough.git
else
  exit 0
if
