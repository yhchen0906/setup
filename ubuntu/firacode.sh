#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

git_clone https://github.com/tonsky/FiraCode.git

post_install << "POST_INSTALL_EOF"
mkdir -p ~/.local/share/fonts
find ~/.local/share/git-resources/FiraCode/distr/ttf -name '*.ttf' -exec ln -sf {} ~/.local/share/fonts/ \;
POST_INSTALL_EOF

fc_cache

finalize
