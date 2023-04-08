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

TELEGRAM_BIN="$OPT_DIR/Telegram/Telegram"
ln -sf "$TELEGRAM_BIN" "$BIN_DIR"

TELEGRAM_PATH_MD5=$(echo -n "$TELEGRAM_BIN" | md5sum | cut -d ' ' -f 1)
TELEGRAM_DESKTOP_NAME="org.telegram.desktop._${TELEGRAM_PATH_MD5}.desktop"

cat > "$APPS_DIR/$TELEGRAM_DESKTOP_NAME" << "EOF"
[Desktop Entry]
Name=Telegram Desktop
Comment=Official desktop version of Telegram messaging app
TryExec=Telegram
Exec=Telegram -- %u
Icon=telegram
Terminal=false
StartupWMClass=TelegramDesktop
Type=Application
Categories=Chat;Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/tg;
Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;
Actions=quit;
SingleMainWindow=true
X-GNOME-UsesNotifications=true
X-GNOME-SingleWindow=true

[Desktop Action quit]
Exec=Telegram -quit
Name=Quit Telegram
Icon=application-exit
EOF

cat > "$AUTOSTART_DIR/$TELEGRAM_DESKTOP_NAME" << "EOF"
[Desktop Entry]
Name=Telegram Desktop
Comment=Official desktop version of Telegram messaging app
TryExec=Telegram
Exec=Telegram -autostart
Icon=telegram
Terminal=false
StartupWMClass=TelegramDesktop
Type=Application
Categories=Chat;Network;InstantMessaging;Qt;
MimeType=x-scheme-handler/tg;
Keywords=tg;chat;im;messaging;messenger;sms;tdesktop;
Actions=quit;
SingleMainWindow=true
X-GNOME-UsesNotifications=true
X-GNOME-SingleWindow=true
EOF
POST_INSTALL_EOF

finalize
