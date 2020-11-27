#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

API_URL='https://data.services.jetbrains.com/products/releases?code=PCC&latest=true&type=release'
JQ_FILTER='.PCC[0].downloads.linux.link'
DOWNLOAD_URL=$(wget -qO- "$API_URL" | jq -r "$JQ_FILTER")

aria2_download << EOF
$DOWNLOAD_URL
  dir=$TMP_DIR
  out=pycharm-community.tar.gz
EOF

post_install << "POST_INSTALL_EOF"
EXTRACT_DIR=$(mktemp -d -p "$TMP_DIR")
tar zxf "$TMP_DIR/pycharm-community.tar.gz" -C "$EXTRACT_DIR"
PYCHARM_DIR=$(find "$EXTRACT_DIR" -mindepth 1 -maxdepth 1 -printf "%P" -quit)
rm -rf "$OPT_DIR/$PYCHARM_DIR"
mv "$EXTRACT_DIR/$PYCHARM_DIR" "$OPT_DIR"

ln -sf "$OPT_DIR/$PYCHARM_DIR/bin/pycharm.sh" "$BIN_DIR/pycharm"

cat > "$APPS_DIR/pycharm.desktop" << "EOF"
[Desktop Entry]
Version=1.0
Name=PyCharm
Comment=The Python IDE for Professional Developers
TryExec=pycharm
Exec=pycharm %F
Icon=pycharm
Type=Application
StartupNotify=false
StartupWMClass=PyCharm
Categories=Utility;Development;IDE;
MimeType=text/plain;inode/directory;
EOF
POST_INSTALL_EOF

finalize
