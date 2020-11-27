#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

apt_install wine64
#aria2_download << EOF
#https://setup.yeeha.xyz/files/windows-fonts.tar.gz
#  dir=$TMP_DIR
#EOF
#
#post_install << "POST_INSTALL_EOF"
#mkdir -p ~/.wine/drive_c/windows/Fonts
#tar zxf "$TMP_DIR/windows-fonts.tar.gz" -C ~/.wine/drive_c/windows/Fonts
#POST_INSTALL_EOF

finalize
