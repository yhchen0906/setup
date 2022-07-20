#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key 'https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB'
add_apt_list oneAPI 'deb https://apt.repos.intel.com/oneapi all main'

apt_install intel-oneapi-vtune

post_install << "POST_INSTALL_EOF"
sudo usermod -aG vtune $(whoami)

cat > "$APPS_DIR/vtune-gui.desktop" << EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=Intel VTune Profiler
GenericName=VTune
Comment=Intel® VTune™ Profiler optimizes application performance, system performance, and system configuration for HPC, cloud, IoT, media, storage, and more.
Exec=bash -c "source /opt/intel/oneapi/vtune/latest/vtune-vars.sh; exec vtune-gui"
Terminal=false
MimeType=text/plain;
Icon=/opt/intel/oneapi/vtune/latest/bin64/resources/app/icons/VTune.png
Categories=Development;
StartupNotify=false
Actions=Window;
EOF
POST_INSTALL_EOF

finalize
