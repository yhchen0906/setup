#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key "https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/xUbuntu_${VERSION_ID}/Release.key"
add_apt_list devel:kubic:libcontainers:stable \
  "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_${VERSION_ID}/ /"
apt_install podman buildah skopeo
[ "$VERSION_ID" = "20.04" ] && apt_install fuse-overlayfs

if [ "$VERSION_ID" = "18.04" ]; then
aria2_download << EOF
https://setup.rogeric.xyz/files/fuse-overlayfs
  dir=$TMP_DIR
  out=fuse-overlayfs
EOF

post_install << "POST_INSTALL_EOF"
sudo install "$TMP_DIR/fuse-overlayfs" /usr/bin
POST_INSTALL_EOF
fi

post_install << "POST_INSTALL_EOF"
sudo ln -sf \
  /usr/share/zsh/site-functions/_podman \
  /usr/local/share/zsh/site-functions/_podman

sudo mkdir -p /usr/share/containers/oci/hooks.d /etc/containers/oci/hooks.d

sudo rm -f /etc/containers/containers.conf
sudo_tee /etc/containers/containers.conf << "EOF"
[containers]
tz = "local"

[engine]
hooks_dir = [
  "/usr/share/containers/oci/hooks.d",
  "/etc/containers/oci/hooks.d"
]
EOF
POST_INSTALL_EOF

finalize
