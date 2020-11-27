#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key 'https://syncthing.net/release-key.txt'
add_apt_list syncthing 'deb https://apt.syncthing.net/ syncthing stable'
sudo_tee /etc/apt/preferences.d/syncthing << "EOF"
Package: *
Pin: origin apt.syncthing.net
Pin-Priority: 990
EOF

apt_install syncthing

finalize
