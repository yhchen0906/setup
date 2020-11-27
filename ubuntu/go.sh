#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://golang.org/dl/go1.14.6.linux-amd64.tar.gz
  dir=$TMP_DIR
  out=go.tar.gz
EOF

post_install << "POST_INSTALL_EOF"
GO_BIN=/usr/local/go/bin
sudo rm -rf /usr/local/go
sudo tar zxf "$TMP_DIR/go.tar.gz" -C /usr/local
NEW_PATH=$( (echo "$GO_BIN"; sed -E -n 's#^PATH="(.*)"$#\1#p' /etc/environment | tr ':' '\n' | grep -v -F "$GO_BIN") | tr '\n' ':' | sed -E 's#:+$##')
sudo sed "s#^PATH=.*#PATH=\"$NEW_PATH\"#g" -i /etc/environment
POST_INSTALL_EOF

finalize
