#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

version='6.0.0'
aria2_download << EOF
https://cdn.joypixels.com/arch-linux/font/${version}/joypixels-android.ttf
  dir=$HOME/.local/share/fonts
EOF

if [ "$VERSION_ID" = "18.04" ]; then
  post_install << "POST_INSTALL_EOF"
sudo patch -d /etc/fonts -p 1 -r - -N << "EOF"
diff -Naur fonts/conf.avail/45-generic.conf fonts-patched/conf.avail/45-generic.conf
--- fonts/conf.avail/45-generic.conf	2020-06-15 17:13:09.530340161 +0800
+++ fonts-patched/conf.avail/45-generic.conf	2020-06-15 17:12:45.873974979 +0800
@@ -6,6 +6,10 @@
 <!-- Emoji -->

 	<alias binding="same">
+		<family>JoyPixels</family>
+		<default><family>emoji</family></default>
+	</alias>
+	<alias binding="same">
 		<family>Emoji Two</family>
 		<default><family>emoji</family></default>
 	</alias>
diff -Naur fonts/conf.avail/60-generic.conf fonts-patched/conf.avail/60-generic.conf
--- fonts/conf.avail/60-generic.conf	2020-06-15 17:13:09.494339605 +0800
+++ fonts-patched/conf.avail/60-generic.conf	2020-06-15 17:12:45.869974917 +0800
@@ -29,6 +29,7 @@
 	<alias binding="same">
 		<family>emoji</family>
 		<prefer>
+			<family>JoyPixels</family>
 			<family>Emoji Two</family>
 			<family>Emoji One</family>
 			<!-- System fonts -->
EOF
POST_INSTALL_EOF
fi

fc_cache

finalize
