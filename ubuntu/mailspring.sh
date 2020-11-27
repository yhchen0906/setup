#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://updates.getmailspring.com/download?platform=linuxDeb
  dir=$TMP_DIR
  out=mailspring.deb
EOF

apt_install "$TMP_DIR/mailspring.deb"

finalize
