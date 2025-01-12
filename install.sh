#!/bin/bash

cd ~/

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si


echo "Yay is installed"


cd ~/arch_install


pacman -S fail2ban ufw screenfetch amd-ucode hugo neovim ansible hugo 

yay -S librewolf-bin spotify ruskdesk-bin anki-bin freetube-bin managa-bin bat bat-extra eza ani-cli ytfzf  obsidian dobe-source-code-pro-fonts cantarell-fonts fontconfig freetype2 gnu-free-fonts lib32-fontconfig lib32-freetype2 libfontenc libxfont2 libxft noto-fonts-emoji ttf-jetbrains-mono-nerd ttf-liberation woff2 xorg-fonts-encodings

# Ask the user if they want to set up fail2ban, change SSH port, and configure UFW for SSH security
read -p "Do you want to secure SSH by setting up fail2ban, changing SSH port, and using SSH keys? (yes/no) " response

# Check if the user entered "yes"
if [[ "$response" == "yes" ]]; then
    echo "Securing SSH with fail2ban, changing SSH port, and configuring UFW..."

    # Step 1: Install fail2ban if not already installed
    if ! command -v fail2ban-client &> /dev/null; then
        echo "Installing fail2ban..."
        sudo pacman -S --noconfirm fail2ban
    else
        echo "fail2ban is already installed."
    fi

    # Step 2: Enable and start fail2ban
    echo "Starting and enabling fail2ban..."
    sudo systemctl enable --now fail2ban

    # Step 3: Configure fail2ban for SSH
    echo "Securing SSH with fail2ban..."
    if ! sudo fail2ban-client status sshd &> /dev/null; then
        echo "Configuring fail2ban for SSH..."
        sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
        sudo sed -i 's/^enabled = false/enabled = true/' /etc/fail2ban/jail.local
        sudo sed -i 's/^port = ssh/port = ssh/' /etc/fail2ban/jail.local
        sudo systemctl restart fail2ban
        echo "fail2ban is now protecting SSH."
    else
        echo "SSH is already protected by fail2ban."
    fi

    # Step 4: Install UFW if not installed
    if ! command -v ufw &> /dev/null; then
        echo "Installing UFW..."
        sudo pacman -S --noconfirm ufw
    else
        echo "UFW is already installed."
    fi

    # Step 5: Configure UFW to allow SSH and block everything else
    echo "Configuring UFW to allow SSH and block everything else..."
    sudo ufw default deny incoming  # Block all incoming connections by default
    sudo ufw default allow outgoing  # Allow all outgoing connections
    sudo ufw allow ssh              # Allow SSH (default port 22)
    sudo ufw enable                 # Enable UFW

    # Step 6: Change SSH Port
    read -p "Enter the new SSH port number (default: 2222): " ssh_port
    ssh_port="${ssh_port:-2222}"  # Default to 2222 if no input is given
    echo "Changing SSH port to $ssh_port..."

    # Update SSH configuration to listen on the new port
    sudo sed -i "s/^#Port 22/Port $ssh_port/" /etc/ssh/sshd_config

    # Step 7: Disable Password-based Authentication and enforce SSH keys
    echo "Disabling password-based authentication and enabling SSH key authentication..."
    sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
    sudo sed -i 's/^#ChallengeResponseAuthentication yes/ChallengeResponseAuthentication no/' /etc/ssh/sshd_config
    sudo sed -i 's/^#UsePAM yes/UsePAM no/' /etc/ssh/sshd_config

    # Restart SSH to apply changes
    sudo systemctl restart sshd

    echo "SSH is now secured with fail2ban, custom port, and SSH key-based authentication."
else
    echo "SSH security setup cancelled."
fi
read -p "Do you want to do GPU passthrough(y/N)"

if [[ "$response" =~ ^[Yy] ]]; then
  git clone https://github.com/HikariKnight/quickpassthrough.git
  pacman -S qemu libvirt edk2-ovmf virt-manager ebtables dnsmasq
  yay -S looking-glass
else
  exit 0
if


pacman -S --needed git base-devel
git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyDE
cd ~/HyDE/Scripts
./install.sh



