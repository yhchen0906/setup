#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
  dir=$TMP_DIR
  out=google-chrome.deb
EOF

apt_install "$TMP_DIR/google-chrome.deb"

post_install << "POST_INSTALL_EOF"
xdg-settings set default-web-browser google-chrome.desktop
POST_INSTALL_EOF

finalize
