#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://go.skype.com/skypeforlinux-64.deb
  dir=$TMP_DIR
  out=skype.deb
EOF

apt_install "$TMP_DIR/skype.deb"

finalize
