#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

git_clone ~/.local/share/themes https://github.com/EliverLara/Ant.git
git_clone ~/.local/share/themes https://github.com/EliverLara/Ant-Bloody.git
git_clone ~/.local/share/themes https://github.com/EliverLara/Ant-Dracula.git
git_clone ~/.local/share/themes https://github.com/EliverLara/Ant-Nebula.git

git_clone ~/.local/share/themes https://github.com/EliverLara/Nordic.git
git_clone ~/.local/share/themes https://github.com/EliverLara/Nordic-Polar.git

post_install << "POST_INSTALL_EOF"
theme=${THEME:-Ant}
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
gsettings set org.gnome.desktop.wm.preferences theme "$theme"
dconf write /org/gnome/shell/extensions/user-theme/name "'$theme'"
POST_INSTALL_EOF

finalize
