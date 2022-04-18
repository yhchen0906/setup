#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key https://nvidia.github.io/nvidia-container-runtime/gpgkey
distro=$ID$VERSION_ID
sudo wget -qO /etc/apt/sources.list.d/nvidia-container-runtime.list \
  "https://nvidia.github.io/nvidia-container-runtime/$distro/nvidia-container-runtime.list"
apt_install nvidia-container-runtime

post_install << "POST_INSTALL_EOF"
sudo sed -E 's;#?(no-cgroups =).*;\1 true;g' -i /etc/nvidia-container-runtime/config.toml
sudo mkdir -p /usr/share/containers/oci/hooks.d
sudo_tee /usr/share/containers/oci/hooks.d/nvidia-container-runtime.json << "EOF"
{
  "version": "1.0.0",
  "hook": {
    "path": "/usr/bin/nvidia-container-runtime-hook",
    "args": ["nvidia-container-runtime-hook", "prestart"]
  },
  "when": { "always": true },
  "stages": ["prestart"]
}
EOF
POST_INSTALL_EOF

finalize
