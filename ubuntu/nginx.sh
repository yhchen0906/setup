#! /bin/sh
cd /etc/nginx || exit

cat >| ssl.conf << "EOF"
# HSTS
add_header Strict-Transport-Security "max-age=63072000" always;
# SSL
ssl_protocols       TLSv1.2 TLSv1.3;
ssl_session_cache   shared:SSL:10m;
ssl_session_timeout 10m;
ssl_session_tickets off;
ssl_dhparam         dh4096.pem;
ssl_ciphers         "EECDH+ECDSA+AESGCM EECDH+aRSA+AESGCM EECDH+ECDSA+SHA384 EECDH+ECDSA+SHA256 EECDH+aRSA+SHA384 EECDH+aRSA+SHA256 EECDH+aRSA+RC4 EECDH EDH+aRSA RC4 !aNULL !eNULL !LOW !3DES !MD5 !EXP !PSK !SRP !DSS !RC4";
ssl_prefer_server_ciphers on;
EOF

umask 077
openssl dhparam -out dh4096.pem 4096
