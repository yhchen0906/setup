#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key microsoft 'https://packages.microsoft.com/keys/microsoft.asc'
add_apt_list vscode 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main'
apt_install code
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
