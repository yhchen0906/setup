#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

apt_install zsh

post_install << "POST_INSTALL_EOF"
wget -qO ~/.zshrc https://setup.yeeha.xyz/files/zimfw.zshrc
sudo chsh -s /bin/zsh $(whoami)
sudo su - -c 'wget -qO ~/.zshrc https://setup.yeeha.xyz/files/zimfw.zshrc'
sudo chsh -s /bin/zsh
POST_INSTALL_EOF

finalize
