#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

sudo_tee "/etc/sudoers.d/$(whoami)" << EOF
$(whoami) ALL=(ALL:ALL) NOPASSWD: ALL
EOF
sudo chmod 0440 "/etc/sudoers.d/$(whoami)"

finalize
