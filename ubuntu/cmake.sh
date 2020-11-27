#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key kitware \
  'https://apt.kitware.com/keys/kitware-archive-latest.asc'
add_apt_list kitware \
  "deb https://apt.kitware.com/ubuntu/ $UBUNTU_CODENAME main"
apt_install cmake cmake-qt-gui cmake-curses-gui

finalize
