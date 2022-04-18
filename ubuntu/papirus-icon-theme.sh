#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

add_ppa ppa:papirus/papirus
apt_install papirus-icon-theme

post_install << "POST_INSTALL_EOF"
gsettings set org.gnome.desktop.interface icon-theme Papirus
POST_INSTALL_EOF

finalize
