#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

apt_install vlc

post_install << "POST_INSTALL_EOF"
sed -nE 's;(video/\S+).*;\1;p' /etc/mime.types | xargs -rtL1 xdg-mime default vlc.desktop
POST_INSTALL_EOF

finalize
