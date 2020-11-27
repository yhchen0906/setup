#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

if [ "$VERSION_ID" = "18.04" ]; then
  API_URL='https://api.github.com/repos/TheAssassin/AppImageLauncher/releases'
  JQ_FILTER='map(select(.prerelease == false) | .assets[].browser_download_url | select(test("'"${UBUNTU_CODENAME}_${ARCH}"'"))) | .[0]'
  DOWNLOAD_URL=$(wget -qO- "$API_URL" | jq -r "$JQ_FILTER")
  aria2_download << EOF
$DOWNLOAD_URL
  dir=$TMP_DIR
  out=appimagelauncher.deb
EOF
  apt_install "$TMP_DIR/appimagelauncher.deb"
elif [ "$VERSION_ID" = "20.04" ]; then
  add_ppa ppa:appimagelauncher-team/stable
  apt_install appimagelauncher
fi

post_install << "POST_INSTALL_EOF"
mkdir -p ~/.config
cat > ~/.config/appimagelauncher.cfg << EOF
[AppImageLauncher]
ask_to_move=true
destination=$OPT_DIR
enable_daemon=true
EOF
POST_INSTALL_EOF

finalize
