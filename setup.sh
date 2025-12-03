#!/bin/bash

# install deps
sudo pacman -Syu --noconfirm
sudo pacman -S --noconfirm --needed git base-devel

## Installing flatpak and setting-up ##
sudo pacman -S --noconfirm --needed flatpak flatpak-kcm
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Installing yay ##
if ! command -v yay &>/dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
fi

## Fixing GTK KDE theme ##
sudo pacman -S --noconfirm --needed xdg-desktop-portal-gtk

mkdir -p ~/.config/xdg-desktop-portal/
echo "[preferred]\ndefault=kde\norg.freedesktop.impl.portal.Settings=kde;gtk;" > ~/.config/xdg-desktop-portal/portals.conf

## Installing firefox ##
flatpak install --user -y flathub org.mozilla.firefox

## Installing Steam ##
flatpak install --user -y flathub com.valvesoftware.Steam
yay -S --noconfirm --needed steam-devices-git

# Allow Steam flatpak create shortcuts in desktop
flatpak override --user --filesystem="$(xdg-user-dir DESKTOP):create" com.valvesoftware.Steam

rm "$HOME/.var/app/com.valvesoftware.Steam/Desktop" &> /dev/null
ln -s "$(xdg-user-dir DESKTOP)" "$HOME/.var/app/com.valvesoftware.Steam/Desktop"

echo -e '#!/bin/bash\nflatpak run com.valvesoftware.Steam "$@"' | sudo tee /usr/local/bin/steam > /dev/null
sudo chmod +x /usr/local/bin/steam

## Installing OBS ##
flatpak install --user -y flathub com.obsproject.Studio
# module to enable virtual camera
sudo pacman -S --noconfirm --needed v4l2loopback-dkms

## Done ##

echo ""
echo "Done, reboot to apply some changes"
