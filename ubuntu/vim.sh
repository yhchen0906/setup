#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

apt_install vim

aria2_download << EOF
https://setup.yeeha.xyz/files/vimrc
  dir=$HOME
  out=.vimrc
https://setup.yeeha.xyz/files/vim.tar
  dir=$TMP_DIR
  out=vim.tar
EOF

post_install << "POST_INSTALL_EOF"
sudo update-alternatives --set editor /usr/bin/vim.basic
tar xf "$TMP_DIR/vim.tar" -C "$HOME"
POST_INSTALL_EOF

finalize
