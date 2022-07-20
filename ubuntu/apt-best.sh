#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

: ${BEST_MIRROR:=$(curl -s http://mirrors.ubuntu.com/mirrors.txt | xargs -n1 -I{} curl -s -r 0-409600 -w "%{speed_download} {}\n" -o /dev/null {}/ls-lR.gz | sort -gr | head -1 | cut -d' ' -f2)}

sudo_tee /etc/apt/sources.list << EOF
deb $BEST_MIRROR $UBUNTU_CODENAME main universe restricted multiverse
deb $BEST_MIRROR $UBUNTU_CODENAME-updates main universe restricted multiverse
deb $BEST_MIRROR $UBUNTU_CODENAME-backports main universe restricted multiverse
deb $BEST_MIRROR $UBUNTU_CODENAME-security main universe restricted multiverse
EOF

finalize
