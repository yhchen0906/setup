#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

API_URL='https://api.github.com/repos/telegramdesktop/tdesktop/releases'
JQ_FILTER='map(select(.prerelease == false) | .assets[] | select(.label == "Linux 64 bit: Binary") | .browser_download_url) | .[0]'
DOWNLOAD_URL=$(wget -qO- "$API_URL" | jq -r "$JQ_FILTER")

aria2_download << EOF
$DOWNLOAD_URL
  dir=$TMP_DIR
  out=tsetup.tar.xz
EOF

post_install << "POST_INSTALL_EOF"
rm -rf "$OPT_DIR/Telegram"
tar Jxf "$TMP_DIR/tsetup.tar.xz" -C "$OPT_DIR"
ln -sf "$OPT_DIR/Telegram/Telegram" "$BIN_DIR"

cat > "$APPS_DIR/telegramdesktop.desktop" << "EOF"
[Desktop Entry]
Version=1.0
Name=Telegram Desktop
Comment=Official desktop version of Telegram messaging app
TryExec=Telegram
Exec=env TDESKTOP_DISABLE_TRAY_COUNTER=1 Telegram -- %u
Icon=telegram
Terminal=false
StartupWMClass=TelegramDesktop
Type=Application
Categories=Chat;Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/tg;
Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;
X-GNOME-UsesNotifications=true
EOF

cat > "$AUTOSTART_DIR/telegramdesktop.desktop" << "EOF"
[Desktop Entry]
Version=1.0
Name=Telegram Desktop
Comment=Official desktop version of Telegram messaging app
TryExec=Telegram
Exec=env TDESKTOP_DISABLE_TRAY_COUNTER=1 Telegram -startintray
Icon=telegram
Terminal=false
StartupWMClass=TelegramDesktop
Type=Application
Categories=Chat;Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/tg;
Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;
X-GNOME-UsesNotifications=true
EOF
POST_INSTALL_EOF

finalize
