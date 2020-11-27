#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

load_setup wine

aria2_download << EOF
https://mt.lv/winbox64
  dir=$OPT_DIR
  out=winbox64.exe
https://setup.yeeha.xyz/files/winbox.png
  dir=$ICONS_DIR
  out=winbox.png
EOF

post_install << "POST_INSTALL_EOF"
cat > "$APPS_DIR/winbox.desktop" << EOF
[Desktop Entry]
Version=1.0
Name=WinBox
Comment=WinBox is a small utility that allows administration of MikroTik RouterOS using a fast and simple GUI.
TryExec=$OPT_DIR/winbox64.exe
Exec=env LC_ALL=zh_TW.BIG5 wine64 $OPT_DIR/winbox64.exe
Icon=winbox
Terminal=false
StartupWMClass=WinBox
Type=Application
EOF
POST_INSTALL_EOF

finalize
