#!/bin/bash

# updates system
sudo dnf update -y

## Installing flatpak and setting-up ##
sudo dnf install -y flatpak
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

## Installing Steam ##
flatpak install -y flathub com.valvesoftware.Steam
sudo dnf install -y steam-devices

# Allow Steam flatpak create shortcuts in desktop
flatpak override --user --filesystem="$(xdg-user-dir DESKTOP):create" com.valvesoftware.Steam

rm "$HOME/.var/app/com.valvesoftware.Steam/Desktop" &> /dev/null
ln -s "$(xdg-user-dir DESKTOP)" "$HOME/.var/app/com.valvesoftware.Steam/Desktop"

echo -e '#!/bin/bash\nflatpak run com.valvesoftware.Steam "$@"' | sudo tee /usr/local/bin/steam > /dev/null
sudo chmod +x /usr/local/bin/steam

## Done ##

echo ""
echo "Done, reboot to apply some changes"

