#! /bin/sh
mkdir -p ~/.ssh/sockets
chmod 700 ~/.ssh
cat > ~/.ssh/config << "EOF"
Host *
  LogLevel ERROR
  ServerAliveInterval 10
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
  Compression yes
  ControlMaster auto
  ControlPersist yes
  ControlPath ~/.ssh/sockets/%r@%h:%p
  #ForwardAgent yes
  #ForwardX11 yes
EOF
