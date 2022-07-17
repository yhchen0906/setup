#! /bin/sh
HEADER_INCLUDED=1

do_initialize() {
  . /etc/os-release
  ARCH=$(dpkg --print-architecture)

  TMP_DIR=$(mktemp -d -p /tmp setup.XXXXXX)
  chmod a+x "$TMP_DIR"

  APT_KEY_LIST=$TMP_DIR/apt-keys
  PPA_REPO_LIST=$TMP_DIR/ppa-repos
  APT_PACKAGE_LIST=$TMP_DIR/apt-packages
  GIT_REPO_LIST=$TMP_DIR/git-repos
  ARIA2_DOWNLOAD_LIST=$TMP_DIR/aria2-downloads
  POST_INSTALL_SCRIPT=$TMP_DIR/post-install
  GIT_RESOURCES_DIR=$HOME/.local/share/git-resources

  OPT_DIR=$HOME/.local/opt
  BIN_DIR=$HOME/.local/bin
  ICONS_DIR=$HOME/.local/share/icons
  APPS_DIR=$HOME/.local/share/applications
  AUTOSTART_DIR=$HOME/.config/autostart
  mkdir -p "$OPT_DIR" "$BIN_DIR" "$ICONS_DIR" "$APPS_DIR" "$AUTOSTART_DIR"

  if \
    [ ! -x "$(command -v aria2c)" ] || \
    [ ! -x "$(command -v curl)" ] || \
    [ ! -x "$(command -v git)" ] || \
    [ ! -x "$(command -v jq)" ]; then
    sudo apt update -y
    sudo apt install -y aria2 curl git jq
  fi

  BEST_MIRROR=$(curl -s http://mirrors.ubuntu.com/mirrors.txt | xargs -n1 -I{} curl -s -r 0-409600 -w "%{speed_download} {}\n" -o /dev/null {}/ls-lR.gz | sort -gr | head -1 | cut -d' ' -f2)

  if [ ! -x "$(command -v apt-fast)" ]; then
    sudo add-apt-repository -y -n ppa:apt-fast/stable
    sudo apt-get update -y
    sudo debconf-set-selections << "EOF"
apt-fast	apt-fast/maxdownloads	string	8
apt-fast	apt-fast/dlflag	boolean	true
apt-fast	apt-fast/aptmanager	select	apt-get
EOF

    sudo apt-get -f -o 'Dpkg::Options::=--force-confnew' install -y apt-fast
    sudo tee -a /etc/apt-fast.conf << EOF
MIRRORS=('$BEST_MIRROR')
EOF
  fi

  sudo apt-fast update -y
  sudo apt-fast install -y ca-certificates
}

do_add_apt_key() {
  if [ -s "$APT_KEY_LIST" ]; then
    xargs -t -n 1 -a "$APT_KEY_LIST" sudo apt-key add
  fi 
}

do_add_ppa() {
  if [ -s "$PPA_REPO_LIST" ]; then
    xargs -t -n 1 -a "$PPA_REPO_LIST" sudo add-apt-repository -y -n
  fi 
}

do_apt_install() {
  if [ -s "$APT_PACKAGE_LIST" ]; then
    sudo apt-get update -y
    xargs -t -a "$APT_PACKAGE_LIST" sudo apt-fast -f -o 'Dpkg::Options::=--force-confnew' install -y
  fi
}

do_git_clone() {
  if [ -s "$GIT_REPO_LIST" ]; then
    mkdir -p "$GIT_RESOURCES_DIR"
    xargs -t -n 1 -P 0 -a "$GIT_REPO_LIST" git -C "$GIT_RESOURCES_DIR" clone --depth 1
    cat > "$GIT_RESOURCES_DIR/update.sh" << "EOF"
#! /bin/sh
SCRIPT_PATH=$(realpath "$0")
RESOURCE_DIR=$(dirname "$SCRIPT_PATH")
find "$RESOURCE_DIR" -mindepth 1 -maxdepth 1 -type d | xargs -t -I {} git -C {} pull
EOF
    chmod 755 "$GIT_RESOURCES_DIR/update.sh"
    mkdir -p ~/.config/systemd/user
    cat > ~/.config/systemd/user/update-git-resources.service << EOF
[Unit]
Description=Update git resources

[Service]
ExecStart=$HOME/.local/share/git-resources/update.sh
EOF
    cat > ~/.config/systemd/user/update-git-resources.timer << "EOF"
[Unit]
Description=Update git resources every three hours

[Timer]
OnBootSec=10m
OnUnitActiveSec=3h

[Install]
WantedBy=timers.target
EOF
    systemctl --user daemon-reload
    systemctl --user enable --now update-git-resources.timer
  fi
}

do_aria2_download() {
  if [ -s "$ARIA2_DOWNLOAD_LIST" ]; then
    aria2c \
      --max-concurrent-downloads=10 \
      --max-connection-per-server=8 \
      --allow-overwrite=true \
      --auto-file-renaming=false \
      --input-file "$ARIA2_DOWNLOAD_LIST"
  fi
}

do_fc_cache() {
  if [ -n "$DO_FC_CACHE" ]; then
    fc-cache -fv
  fi
}

do_post_install() {
  if [ -s "$POST_INSTALL_SCRIPT" ]; then
    . "$POST_INSTALL_SCRIPT"
  fi
}

do_finalize() {
  do_aria2_download
  do_git_clone
  do_add_apt_key
  do_add_ppa
  do_apt_install
  do_fc_cache
  do_post_install
  rm -r "$TMP_DIR"
}

# run commands from stdin after finalize
# ex:
#   post_install << "POST_INSTALL_EOF"
#     echo "Installation completed."
#   POST_INSTALL_EOF
post_install() {
  cat >> "$POST_INSTALL_SCRIPT"
}

initialize() {
  if [ -z "$DEPTH" ]; then
    DEPTH=0
  else
    DEPTH=$((DEPTH + 1))
  fi

  if [ "$DEPTH" -eq 0 ]; then
    do_initialize
  fi
}

load_setup() {
  printf "%s\n" "$@" | xargs -t -P0 -n1 -I{} wget -qO $TMP_DIR/{}.sh https://setup.rogeric.xyz/ubuntu/{}.sh

  for setup in "$@"; do
    . "$TMP_DIR/$setup.sh"
  done
}

# sudo_tee [path]
# ex:
#   sudo_tee /etc/systemd/timesyncd.conf << "EOF"
#   [Time]
#   NTP=tick.stdtime.gov.tw
#   FallbackNTP=tock.stdtime.gov.tw
#   EOF
sudo_tee() {
  mkdir -p "$(dirname $1)"
  sudo tee "$1" > /dev/null
}

# ex:
#   aria2_download << "EOF"
#   https://mt.lv/winbox64
#     dir=$OPT_DIR
#     out=winbox64.exe
#   EOF
aria2_download() {
  cat >> "$ARIA2_DOWNLOAD_LIST"
}

# add_apt_key [url]
# add_apt_key [name] [url]
# ex:
#   add_apt_key 'https://packages.microsoft.com/keys/microsoft.asc'
#   add_apt_key kitware 'https://apt.kitware.com/keys/kitware-archive-latest.asc'
add_apt_key() {
  if [ "$#" -eq 1 ]; then
    key_path=$(mktemp -p "$TMP_DIR" gpg.XXXXXX)
    aria2_download << EOF
$1
  dir=$(dirname "$key_path")
  out=$(basename "$key_path")
EOF
    echo "$key_path" >> "$APT_KEY_LIST"
  elif [ "$#" -eq 2 ]; then
    wget -qO- "$2" | gpg --dearmor | sudo_tee "/etc/apt/trusted.gpg.d/$1.gpg"
  fi
}

# add_apt_list [list] [content]
# ex: add_apt_list nvidia-cuda 'deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /'
add_apt_list() {
  sudo_tee "/etc/apt/sources.list.d/$1.list" << EOF
$2
EOF
}

# add_ppa [repo ...]
# ex: add_ppa ppa:papirus/papirus ppa:peek-developers/stable
add_ppa() {
  for repo in "$@"; do
    echo "$repo" >> "$PPA_REPO_LIST"
  done
}

# apt_install [package ...]
# ex: apt_install aria2 git jq
apt_install() {
  for package in "$@"; do
    echo "$package" >> "$APT_PACKAGE_LIST"
  done
}

# git_clone [repo]
# ex: https://github.com/tonsky/FiraCode.git
# git_clone [path] [repo]
# ex: git_clone ~/.local/share/themes https://github.com/EliverLara/Ant.git
git_clone() {
  [ "$#" -eq 1 ] && repo=$1
  [ "$#" -eq 2 ] && repo=$2
  clone_path=$GIT_RESOURCES_DIR/$(basename "$repo" .git)

  if [ "$#" -eq 2 ]; then
    mkdir -p "$1"
    ln -sf "$clone_path" "$1"
  fi

  if [ -d "$clone_path" ] && [ "$(git -C "$clone_path" config --get remote.origin.url)" = "$repo" ]; then
    echo "Already cloned."
  else
    rm -rf "$clone_path"
    echo "$repo" >> "$GIT_REPO_LIST"
  fi
}

fc_cache() {
  DO_FC_CACHE=1
}

finalize() {
  if [ "$DEPTH" -eq 0 ]; then
    do_finalize
  fi
  DEPTH=$((DEPTH - 1))
}
