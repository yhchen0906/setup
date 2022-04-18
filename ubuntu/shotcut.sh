#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

apt_install libjack0

API_URL='https://api.github.com/repos/mltframework/shotcut/releases/latest'
JQ_FILTER='.assets[].browser_download_url | select(test("shotcut-linux-x86_64-\\d+\\.txz$"))'
DOWNLOAD_URL=$(wget -qO- "$API_URL" | jq -r "$JQ_FILTER")

aria2_download << EOF
$DOWNLOAD_URL
  dir=$TMP_DIR
  out=shotcut.txz
EOF

post_install << "POST_INSTALL_EOF"
rm -rf "$OPT_DIR/Shotcut"
tar Jxf "$TMP_DIR/shotcut.txz" -C "$OPT_DIR"

cp -rT "$OPT_DIR/Shotcut/Shotcut.app/share/icons" "$ICONS_DIR"
cp -rT "$OPT_DIR/Shotcut/Shotcut.app/share/applications" "$APPS_DIR"

ln -sf "$OPT_DIR/Shotcut/Shotcut.app/shotcut" "$BIN_DIR"
POST_INSTALL_EOF

finalize
