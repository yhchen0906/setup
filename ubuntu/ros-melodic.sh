#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key \
  'http://keyserver.ubuntu.com/pks/lookup?op=get&search=0xC1CF6E31E6BADE8868B172B4F42ED6FBAB17C654'
add_apt_list ros-latest \
  "deb http://packages.ros.org/ros/ubuntu $UBUNTU_CODENAME main"
apt_install \
  python-rosdep \
  ros-melodic-desktop-full

post_install << "POST_INSTALL_EOF"
mkdir -p ~/.ignition/fuel
cat > ~/.ignition/fuel/config.yaml << EOF
---
servers:
  -
    name: osrf
    url: https://api.ignitionrobotics.org
EOF
POST_INSTALL_EOF

finalize
