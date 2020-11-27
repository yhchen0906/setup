#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

post_install << "POST_INSTALL_EOF"
sudo apt-fast install -y $(check-language-support)
POST_INSTALL_EOF

finalize
