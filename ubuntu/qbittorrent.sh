#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

add_ppa ppa:qbittorrent-team/qbittorrent-stable
apt_install qbittorrent

finalize
