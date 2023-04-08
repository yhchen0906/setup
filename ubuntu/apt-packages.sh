#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

sudo apt-get purge -y snapd

sudo debconf-set-selections << "EOF"
msttcorefonts msttcorefonts/accepted-mscorefonts-eula select true
EOF

apt_install \
  apg \
  axel \
  cheese \
  chrome-gnome-shell \
  cmatrix \
  cowsay \
  curl \
  dconf-editor \
  debconf-utils \
  default-jre \
  direnv \
  dos2unix \
  exfat-utils \
  fd-find \
  figlet \
  fonts-powerline \
  fonts-wqy-microhei \
  fzf \
  gimp \
  git \
  gnome-calculator \
  gnome-calendar \
  gnome-characters \
  gnome-clocks \
  gnome-contacts \
  gnome-logs \
  gnome-weather \
  gnome-sound-recorder \
  gnome-system-monitor \
  gnome-tweaks \
  gparted \
  gpick \
  htop \
  libcanberra-gtk-module \
  lm-sensors \
  lolcat \
  mosh \
  ncurses-term \
  openssh-server \
  p7zip-full \
  pigz \
  remmina \
  rhythmbox \
  ruby \
  screenfetch \
  shotwell \
  sl \
  tmux \
  tree \
  ubuntu-restricted-extras \
  unar \
  unrar \
  wget \
  wine64 \
  xclip \
  zstd

if [ "$VERSION_ID" = "20.04" ]; then
  apt_install \
    appmenu-gtk2-module \
    appmenu-gtk3-module \
    okular \
    ripgrep
fi

finalize
