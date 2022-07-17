#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

sudo_tee /etc/apt/sources.list << EOF
deb $BEST_MIRROR $UBUNTU_CODENAME main universe restricted multiverse
deb $BEST_MIRROR $UBUNTU_CODENAME-updates main universe restricted multiverse
deb $BEST_MIRROR $UBUNTU_CODENAME-backports main universe restricted multiverse
deb $BEST_MIRROR $UBUNTU_CODENAME-security main universe restricted multiverse
EOF

finalize
