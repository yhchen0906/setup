#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key https://dl-ssl.google.com/linux/linux_signing_key.pub
add_apt_list google-chrome 'deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main'
apt_install google-chrome-stable
post_install << "POST_INSTALL_EOF"
xdg-settings set default-web-browser google-chrome.desktop
POST_INSTALL_EOF

finalize
