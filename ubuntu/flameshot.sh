#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

apt_install flameshot

post_install << "POST_INSTALL_EOF"
mkdir -p ~/.config/Dharkael
cat > ~/.config/Dharkael/flameshot.ini << "EOF"
[General]
disabledTrayIcon=true
EOF

cat > "$AUTOSTART_DIR/Flameshot.desktop" << "EOF"
[Desktop Entry]
Name=flameshot
Icon=flameshot
Exec=flameshot
Terminal=false
Type=Application
X-GNOME-Autostart-enabled=true
EOF

dconf load /org/gnome/settings-daemon/plugins/media-keys/ << "EOF"
[/]
custom-keybindings=['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']

[custom-keybindings/custom0]
binding='<Shift><Super>s'
command='flameshot gui'
name='Flameshot'
EOF
POST_INSTALL_EOF

finalize
