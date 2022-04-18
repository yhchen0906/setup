#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

GNOME_SITE='https://extensions.gnome.org'
SHELL_VERSION=$(gnome-shell --version | tr -cd "0-9." | cut -d'.' -f-2)

[ "$VERSION_ID" = "18.04" ] && ENABLE_EXTENSION='gnome-shell-extension-tool -e'
: ${ENABLE_EXTENSION:='gnome-extensions enable'}

[ "$VERSION_ID" = "20.04" ] && sudo apt-get purge -y --autoremove gnome-shell-extension-desktop-icons
sudo apt-get purge -y --autoremove \
  gnome-shell-extension-appindicator \
  gnome-shell-extension-ubuntu-dock

mkdir -p ~/.local/share/gnome-shell/extensions

install_gnome_extension() {
  api_url="$GNOME_SITE/extension-info/?pk=$1&shell_version=$SHELL_VERSION"
  api_response=$(mktemp -p "$TMP_DIR" gnome-extension-info.XXXXXX)
  wget -qO "$api_response" "$api_url"
  uuid=$(jq -r '.uuid' "$api_response")
  extension_dir="$HOME/.local/share/gnome-shell/extensions/$uuid"
  download_uri=$(jq -r '.download_url' "$api_response")
  download_url="$GNOME_SITE$download_uri"

  aria2_download << EOF
$download_url
  dir=$TMP_DIR
  out=$uuid.zip
EOF

  post_install << POST_INSTALL_EOF
rm -rf "$extension_dir"
mkdir -p "$extension_dir"
unzip -q "$TMP_DIR/$uuid.zip" -d "$extension_dir"
$ENABLE_EXTENSION $uuid
POST_INSTALL_EOF
}

# User Themes
install_gnome_extension 19

# gTile
install_gnome_extension 28

# Clipboard Indicator
install_gnome_extension 779

# Gravatar
#install_gnome_extension 1015

# Dash to Panel
install_gnome_extension 1160

# Top Indicator App
install_gnome_extension 3681

post_install << "POST_INSTALL_EOF"
dconf reset -f /org/gnome/shell/extensions/dash-to-panel/
dconf load /org/gnome/shell/extensions/ << "EOF"
[dash-to-panel]
animate-show-apps=false
isolate-workspaces=true
click-action='TOGGLE-SHOWPREVIEW'
dot-style-focused='SEGMENTED'
dot-style-unfocused='SEGMENTED'
hot-keys=true
hotkeys-overlay-combo='TEMPORARILY'
EOF
POST_INSTALL_EOF

if [ "$VERSION_ID" = "20.04" ]; then
  # Desktop Icons NG (DING)
  install_gnome_extension 2087
  post_install << "POST_INSTALL_EOF"
dconf reset -f /org/gnome/shell/extensions/ding/
dconf load /org/gnome/shell/extensions/ << "EOF"
[ding]
show-home=false
show-volumes=false
EOF
POST_INSTALL_EOF
fi

post_install << "POST_INSTALL_EOF"
busctl --user call org.gnome.Shell /org/gnome/Shell org.gnome.Shell Eval s 'Meta.restart("Restarting…")'
POST_INSTALL_EOF

finalize
