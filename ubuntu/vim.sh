#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

apt_install vim

cat > ~/.vimrc << "EOF"
colo elflord
syn on
se mouse=""
se ai si cin
se nu ru is hls
se nowrap t_Co=256
se et ts=2 sw=2 sts=2
se fencs=utf8,big5,gbk,latin1
highlight LineNr ctermfg=gray
map <F2> :w<CR>:!clear ; echo "\033[0;31m[Compiling]\033[0m" ; clang++ % --pedantic -Wall -O2 -std=c++14 -o %:r && echo "\033[0;31m[Compiled]\n[Running]\033[0m" && ./%:r && echo "\033[0;31m[Terminated]\033[0m"<CR>
map <F4> :w<CR>:!clear ; ./%<CR>
EOF

post_install << "POST_INSTALL_EOF"
sudo update-alternatives --set editor /usr/bin/vim.basic
POST_INSTALL_EOF

finalize
