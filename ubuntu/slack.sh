#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key 'https://packagecloud.io/slacktechnologies/slack/gpgkey'
add_apt_list slack 'deb https://packagecloud.io/slacktechnologies/slack/debian/ jessie main'
apt_install slack-desktop

post_install << "POST_INSTALL_EOF"
mkdir -p ~/.config/Slack/storage
cat > ~/.config/Slack/storage/root-state.json << "EOF"
{"settings": {"autoHideMenuBar": true}}
EOF
POST_INSTALL_EOF

finalize
