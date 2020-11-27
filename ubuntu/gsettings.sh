#! /bin/sh
. /etc/os-release
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.interface clock-format 24h
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.wm.preferences button-layout "'close,minimize,maximize:'"
gsettings set org.gnome.Terminal.Legacy.Settings theme-variant "'system'"
gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar false
gsettings set org.gnome.shell.app-switcher current-workspace-only true
gsettings set org.gnome.desktop.interface gtk-enable-primary-paste false
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.gedit.preferences.encodings candidate-encodings "['UTF-8', 'BIG5', 'GBK', 'ISO-8859-1']"

if [ "$VERSION_ID" = "18.04" ]; then
  gsettings set org.gnome.nautilus.desktop volumes-visible false
  gsettings set org.gnome.nautilus.desktop trash-icon-visible false
  gsettings set org.gnome.settings-daemon.plugins.media-keys home "'<Super>e'"
elif [ "$VERSION_ID" = "20.04" ]; then
  gsettings set org.gnome.settings-daemon.plugins.media-keys home "['<Super>e']"
fi
