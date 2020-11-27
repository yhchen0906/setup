#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

apt_install resolvconf

post_install << "POST_INSTALL_EOF"
sudo ln -sf /run/resolvconf/resolv.conf /etc/resolv.conf
POST_INSTALL_EOF

finalize
