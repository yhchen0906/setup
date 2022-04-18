#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

post_install << "POST_INSTALL_EOF"
sudo apt-fast dist-upgrade -y
sudo apt-get autoremove -y --purge
sudo apt-get purge -y $(dpkg -l | grep '^rc' | cut -d' ' -f3)
sudo apt-get autoclean
POST_INSTALL_EOF

finalize
