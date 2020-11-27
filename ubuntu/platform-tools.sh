#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://dl.google.com/android/repository/platform-tools-latest-linux.zip
  dir=$TMP_DIR
  out=platform-tools-linux.zip
EOF

post_install << "POST_INSTALL_EOF"
unzip "$TMP_DIR/platform-tools-linux.zip" -d "$OPT_DIR"

cat >> ~/.profile << "EOF"

# add Android SDK platform tools to path
if [ -d "$HOME/.local/opt/platform-tools" ] ; then
    PATH="$HOME/.local/opt/platform-tools:$PATH"
fi
EOF
POST_INSTALL_EOF

finalize
