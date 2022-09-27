#! /bin/sh
cat >| "/usr/lib/systemd/system/acme-renew.service" << "EOF"
[Unit]
Description=Renew certificates with acme

[Service]
ExecStart=/root/.acme.sh/acme.sh --force --cron --home /root/.acme.sh
EOF

cat >| "/usr/lib/systemd/system/acme-renew.timer" << "EOF"
[Unit]
Description=Renew certificates with acme every month.

[Timer]
Persistent=true
OnCalendar=*-1 01:00

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable acme-renew.timer
