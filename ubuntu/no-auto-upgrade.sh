#! /bin/sh
sudo sed -E 's;"1";"0";g' -i \
  /etc/apt/apt.conf.d/10periodic \
  /etc/apt/apt.conf.d/20auto-upgrades

sudo sed -E 's;^([^#].*);#\1;g' -i /etc/apt/apt.conf.d/99update-notifier

sudo systemctl disable --now apt-daily.timer apt-daily-upgrade.timer

mkdir -p ~/.config/autostart
cat > ~/.config/autostart/update-notifier.desktop << EOF
$(cat /etc/xdg/autostart/update-notifier.desktop)
X-GNOME-Autostart-enabled=false
EOF
