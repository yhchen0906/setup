#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

API_URL='https://api.github.com/repos/telegramdesktop/tdesktop/releases'
JQ_FILTER='map(select(.prerelease == false) | .assets[] | select(.label == "Linux 64 bit: Binary") | .browser_download_url) | .[0]'
DOWNLOAD_URL=$(wget -qO- "$API_URL" | jq -r "$JQ_FILTER")

aria2_download << EOF
$DOWNLOAD_URL
  dir=$TMP_DIR
  out=tsetup.tar.xz
EOF

post_install << "POST_INSTALL_EOF"
rm -rf "$OPT_DIR/Telegram"
tar Jxf "$TMP_DIR/tsetup.tar.xz" -C "$OPT_DIR"

"$OPT_DIR/Telegram/Telegram" -autostart > /dev/null 2>&1
POST_INSTALL_EOF

finalize
