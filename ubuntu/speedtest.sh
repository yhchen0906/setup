#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

sudo apt-key adv --keyserver 'keyserver.ubuntu.com' --recv-keys '379CE192D401AB61'
add_apt_list speedtest 'deb https://ookla.bintray.com/debian generic main'
apt_install speedtest

finalize
