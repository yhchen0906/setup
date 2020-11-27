#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

version=$(echo "$VERSION_ID" | tr -d '.')
sudo wget -qO /etc/apt/preferences.d/cuda-repository-pin-600 \
  "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$version/x86_64/cuda-ubuntu$version.pin"
sudo apt-key adv --fetch-keys \
  "https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$version/x86_64/7fa2af80.pub"
add_apt_list cuda \
  "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu$version/x86_64/ /"
add_apt_list nvidia-ml \
  "deb https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu$version/x86_64 /"
apt_install cuda-drivers

post_install << "POST_INSTALL_EOF"
sudo nvidia-xconfig --allow-empty-initial-configuration --cool-bits=4 --enable-all-gpus
POST_INSTALL_EOF

finalize
