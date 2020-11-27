#! /bin/sh
sudo tee /usr/lib/sysctl.d/51-tcp-bbr.conf << "EOF"
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
EOF
sudo sysctl --system
