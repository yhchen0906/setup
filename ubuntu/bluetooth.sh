#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

cat > "$AUTOSTART_DIR/bluetooth.desktop" << "EOF"
[Desktop Entry]
Type=Application
Exec=/bin/sh -c "sleep 5; echo 'paired-devices' | bluetoothctl | sed -nE 's;^Device (\\S+) .*;connect \\1;p' | bluetoothctl"
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Bluetooth
Icon=bluetooth
Comment=Connect to paired bluetooth devices at startup
EOF

finalize
