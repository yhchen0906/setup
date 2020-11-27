#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
  dir=$HOME/.local/share/fonts
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
  dir=$HOME/.local/share/fonts
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
  dir=$HOME/.local/share/fonts
https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
  dir=$HOME/.local/share/fonts
EOF

post_install << "POST_INSTALL_EOF"
dconf load /org/gnome/terminal/legacy/profiles:/ << EOF
[:$(gsettings get org.gnome.Terminal.ProfilesList default | xargs)]
font='MesloLGS NF 14'
EOF
POST_INSTALL_EOF

fc_cache

finalize
