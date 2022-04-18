#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

API_URL='https://api.github.com/repos/sindresorhus/caprine/releases/latest'
JQ_FILTER='.assets[].browser_download_url | select(endswith(".deb"))'
DOWNLOAD_URL=$(wget -qO- "$API_URL" | jq -r "$JQ_FILTER")

aria2_download << EOF
$DOWNLOAD_URL
  dir=$TMP_DIR
  out=caprine.deb
EOF

apt_install "$TMP_DIR/caprine.deb"

post_install << "POST_INSTALL_EOF"
ln -sf /usr/share/applications/caprine.desktop "$AUTOSTART_DIR"

mkdir -p ~/.config/Caprine
cat > ~/.config/Caprine/config.json << EOF
{
  "autoHideMenuBar": true
}
EOF
POST_INSTALL_EOF

finalize
