#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi
initialize

add_apt_key "https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_$VERSION_ID/Release.key"
add_apt_list home:manuelschneid3r \
  "deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$VERSION_ID/ /"
apt_install albert

post_install << "POST_INSTALL_EOF"
ln -sf /usr/share/applications/albert.desktop "$AUTOSTART_DIR"

mkdir -p ~/.config/albert
cat > ~/.config/albert/albert.conf << "EOF"
[General]
hotkey=Alt+Space
showTray=false

[org.albert.extension.applications]
enabled=true

[org.albert.extension.calculator]
enabled=true

[org.albert.frontend.widgetboxmodel]
alwaysOnTop=true
clearOnHide=false
displayIcons=true
displayScrollbar=false
displayShadow=true
hideOnClose=false
hideOnFocusLoss=true
itemCount=5
showCentered=true
theme=Bright
EOF
POST_INSTALL_EOF

finalize
