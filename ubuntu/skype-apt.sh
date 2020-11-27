#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key 'https://repo.skype.com/data/SKYPE-GPG-KEY'
add_apt_list skype-stable 'deb [arch=amd64] https://repo.skype.com/deb stable main'
apt_install skypeforlinux

finalize
