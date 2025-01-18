#!/bin/bash

cd ~/

git clone https://aur.archlinux.org/yay.git

cd yay

makepkg -si


echo "Yay is installed"


cd ~/arch_install


sudo pacman -S fail2ban ufw screenfetch amd-ucode hugo neovim ansible hugo  openssh doas

yay -S librewolf-bin spotify ruskdesk-bin anki-bin freetube-bin managa-bin bat bat-extra eza ani-cli ytfzf  obsidian dobe-source-code-pro-fonts cantarell-fonts fontconfig freetype2 gnu-free-fonts lib32-fontconfig lib32-freetype2 libfontenc libxfont2 libxft noto-fonts-emoji ttf-jetbrains-mono-nerd ttf-liberation woff2 xorg-fonts-encodings tldr arch-wiki-man



echo  "permit liam as root"

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
    break
fi


pacman -S --needed git base-devel

# Clone the repository
git clone --depth 1 https://github.com/prasanthrangan/hyprdots ~/HyDE

# Modify dotfiles before running the install script
echo "alias man='batman'" >> /home/liam/HyDE/Scripts/.zshrc
echo "alias sudo='doas'" >> /home/liam/HyDE/Scripts/.zshrc
echo "alias manga='manga-tui'" >> /home/liam/HyDE/Scripts/.zshrc
echo "alias ani='ani-cli'" >> /home/liam/HyDE/Scripts/.zshrc
echo "alias cat='bat'" >> /home/liam/HyDE/Scripts/.zshrc

# Modify monitor configuration in Hypr
echo "monitor=DP-1,1680x1050@58.03,656x50,1.0" >> /home/liam/HyDE/Scripts/.config/hypr/monitors.conf
echo "monitor=DP-1,transform,1" >> /home/liam/HyDE/Scripts/.config/hypr/monitors.conf
echo "monitor=HDMI-A-1,2560x1080@75.0,1706x233,1.0" >> /home/liam/HyDE/Scripts/.config/hypr/monitors.conf

# Modify hyprland.conf using sed
config_file="/home/liam/HyDE/Scripts/.config/hypr/hyprland.conf"

sed -i '
15c\
$browser = librewolf\n$note = obsidian\n$music = spotify
22c\
bind = $mainMod+Shift, W, togglefloating, # toggle the window between focus and float
24c\
bind = $mainMod, F, fullscreen, # toggle the window between focus and fullscreen
28,29c\
bind = Ctrl+Alt, W, exec, killall waybar || waybar # toggle waybar
32c\
bind = $mainMod, Return, exec, $term # launch terminal emulator
35c\
bind = $mainMod, W, exec, $browser # launch web browser\nbind = $mainMod, O, exec, $note # launch obsidian\nbind = $mainMod, S, exec, $music # launch spotify
37c\
bind = $mainMod+Shift, G, exec, /home/liam/.bin/gaming-start\nbind = Ctrl+Alt, Q, exec, ~/.config/hypr/hyprlock.sh
81,82c\
bind = $mainMod+Ctrl, W, exec, pkill -x rofi || $scrPath/swwwallselect.sh # launch wallpaper select menu
87,88c\
bind = $mainMod+Shift, L, exec, bash /home/liam/.local/bin/start-lg.sh
96a\
bind = $mainMod, 1, focusmonitor, HDMI-A-1\nbind = $mainMod, 2, focusmonitor, HDMI-A-1\nbind = $mainMod, 3, focusmonitor, HDMI-A-1\nbind = $mainMod, 4, focusmonitor, HDMI-A-1\nbind = $mainMod, 5, focusmonitor, HDMI-A-1\nbind = $mainMod, 6, focusmonitor, DP-1\nbind = $mainMod, 7, focusmonitor, DP-1\nbind = $mainMod, 8, focusmonitor, DP-1\nbind = $mainMod, 9, focusmonitor, DP-1\nbind = $mainMod, 0, focusmonitor, DP-1
107a\
\n# enable or display nightlight\nbind = $mainMod, F9, exec, wlsunset -T 6500 \nbind = $mainMod, F10, exec, pkill wlsunset\n
122,131c\
bind = $mainMod+Ctrl, 1, movetoworkspace, 1\nbind = $mainMod+Ctrl, 2, movetoworkspace, 2\nbind = $mainMod+Ctrl, 3, movetoworkspace, 3\nbind = $mainMod+Ctrl, 4, movetoworkspace, 4\nbind = $mainMod+Ctrl, 5, movetoworkspace, 5\nbind = $mainMod+Ctrl, 6, movetoworkspace, 6\nbind = $mainMod+Ctrl, 7, movetoworkspace, 7\nbind = $mainMod+Ctrl, 8, movetoworkspace, 8\nbind = $mainMod+Ctrl, 9, movetoworkspace, 9\nbind = $mainMod+Ctrl, 0, movetoworkspace, 10
139,142c\
binded = $mainMod SHIFT $CONTROL, left,Move activewindow to the right,exec, $moveactivewindow -30 0 || hyprctl dispatch movewindow l\nbinded = $mainMod SHIFT $CONTROL, right,Move activewindow to the right,exec, $moveactivewindow 30 0 || hyprctl dispatch movewindow r\nbinded = $mainMod SHIFT $CONTROL, up,Move activewindow to the right,exec, $moveactivewindow  0 -30 || hyprctl dispatch movewindow u\nbinded = $mainMod SHIFT $CONTROL, down,Move activewindow to the right,exec, $moveactivewindow 0 30 || hyprctl dispatch movewindow d
156c\
bind = $mainMod+Shift, S, togglespecialworkspace,
' "$config_file"

echo "Changes applied successfully. A backup of the original file has been saved as $config_file.bak"

# Path to the workspaces configuration file
workspace_config="/home/liam/HyDE/Scripts/.config/hypr/workspaces.conf"

# Backup the original file
cp "$workspace_config" "$workspace_config.bak"

# Append new lines to the workspaces configuration file
cat <<EOF >> "$workspace_config"

# Custom window rules
windowrule = workspace 3, obsidian
windowrule = workspace 4, code
windowrule = workspace 5, dolphin
windowrule = workspace 6, kitty
EOF

echo "Lines appended successfully. A backup of the original file has been saved as $workspace_config.bak"

# Path to the hyprland configuration file
hyprland_config="/home/liam/HyDE/Scripts/.config/hypr/hyprland.conf"

# Backup the original file
cp "$hyprland_config" "$hyprland_config.bak"

# Apply changes using sed and append necessary lines
sed -i '
41,42c\
exec-once = ~/.local/bin/start-lg.sh\nexec-once = [workspace 6 silent] spotify\nexec-once = [workspace 2 silent] librewolf\nexec-once = [workspace 1 silent] kitty\nexec-once = [workspace 3 silent] obsidian\nexec-once = [workspace 7 silent] virt-manager\nexec-once = [workspace 8 silent] btop
125a\
plugin {\n    split-monitor-workspaces {\n        count = 5\n        keep_focused = 0\n        enable_notifications = 0\n        enable_persistent_workspaces = 1\n    }\n}
' "$hyprland_config"

echo "Changes applied successfully. A backup of the original file has been saved as $hyprland_config.bak"

# Now run the install script
cd ~/HyDE/Scripts
./install.sh

