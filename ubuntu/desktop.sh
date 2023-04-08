#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

if lspci | grep -iq nvidia; then
  load_setup cuda-drivers nvidia-container-runtime
fi

load_setup \
  sudo-nopasswd \
  net-perf \
  apt-best \
  gsettings

load_setup \
  albert \
  anydesk \
  appimagelauncher \
  apt-packages \
  bluetooth \
  caprine \
  cmake \
  code \
  firacode \
  flameshot \
  gnome-shell-extensions \
  gnome-terminal \
  go \
  google-chrome \
  grub-customizer \
  gtk-themes \
  ibus-chewing \
  joypixels \
  llvm \
  locale \
  mailspring \
  meslolgs-nf \
  miniconda \
  no-apport \
  no-auto-upgrade \
  papirus-icon-theme \
  peek \
  perf \
  platform-tools \
  podman \
  pycharm \
  qbittorrent \
  resolvconf \
  shotcut \
  skype \
  slack \
  ssh \
  syncthing \
  systemd-timesyncd \
  teamviewer \
  telegram \
  vim \
  vlc \
  winbox \
  wps-office \
  xnconvert \
  zimfw

load_setup \
  upgrade-and-clean \
  language-support

post_install << "POST_INSTALL_EOF"
gsettings set org.gnome.shell favorite-apps "['google-chrome.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop', 'org.gnome.Screenshot.desktop', 'code.desktop']"
POST_INSTALL_EOF

finalize
