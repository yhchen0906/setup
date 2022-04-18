#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://download.xnview.com/XnConvert-linux-x64.deb
  dir=$TMP_DIR
  out=xnconvert.deb
EOF

apt_install "$TMP_DIR/xnconvert.deb"

finalize
