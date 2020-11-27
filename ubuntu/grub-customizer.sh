#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

[ "$VERSION_ID" = "18.04" ] && add_ppa ppa:danielrichter2007/grub-customizer
apt_install grub-customizer

finalize
