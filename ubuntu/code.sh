#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://update.code.visualstudio.com/latest/linux-deb-x64/stable
  dir=$TMP_DIR
  out=code.deb
https://setup.rogeric.xyz/files/code-nautilus.py
  dir=$HOME/.local/share/nautilus-python/extensions
EOF

if [ "$VERSION_ID" = "18.04" ]; then
  apt_install python-nautilus
elif [ "$VERSION_ID" = "20.04" ]; then
  apt_install python3-nautilus
fi

apt_install "$TMP_DIR/code.deb"

post_install << "POST_INSTALL_EOF"
code --install-extension shan.code-settings-sync

mkdir -p ~/.config/Code/User
cat > ~/.config/Code/User/settings.json << "EOF"
{
  "window.titleBarStyle": "custom",
  "sync.autoDownload": true,
  "sync.gist": "ed268eb6a521c3fd1e1d345ba6a2e5ad"
}
EOF

cat > ~/.config/Code/User/syncLocalSettings.json << "EOF"
{
  "downloadPublicGist": true
}
EOF
POST_INSTALL_EOF

finalize
