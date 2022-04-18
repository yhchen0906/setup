#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key 'https://keys.anydesk.com/repos/DEB-GPG-KEY'
add_apt_list anydesk-stable 'deb http://deb.anydesk.com/ all main'
apt_install anydesk

finalize
