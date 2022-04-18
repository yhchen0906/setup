#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
  dir=$TMP_DIR
  out=teamviewer.deb
EOF

apt_install "$TMP_DIR/teamviewer.deb"

finalize
