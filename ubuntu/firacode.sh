#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

API_URL='https://api.github.com/repos/tonsky/FiraCode/releases/latest'
JQ_FILTER='.assets[].browser_download_url'
DOWNLOAD_URL=$(wget -qO- "$API_URL" | jq -r "$JQ_FILTER")

aria2_download << EOF
$DOWNLOAD_URL
  dir=$TMP_DIR
  out=Fira_Code.zip
EOF

post_install << "POST_INSTALL_EOF"
mkdir -p ~/.local/share/fonts
unzip "$TMP_DIR/Fira_Code.zip" -d "$TMP_DIR/Fira_Code"
find "$TMP_DIR/Fira_Code/ttf" -type f -name '*.ttf' -exec cp {} ~/.local/share/fonts \;
POST_INSTALL_EOF

finalize
