#! /bin/sh
sudo tee /etc/systemd/timesyncd.conf << "EOF"
[Time]
NTP=tick.stdtime.gov.tw
FallbackNTP=tock.stdtime.gov.tw
EOF
sudo systemctl enable --now systemd-timesyncd
