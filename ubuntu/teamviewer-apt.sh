#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key 'https://download.teamviewer.com/download/linux/signature/TeamViewer2017.asc'
add_apt_list teamviewer 'deb http://linux.teamviewer.com/deb stable main'
apt_install teamviewer

finalize
