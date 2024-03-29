#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

version='7.0.0'
aria2_download << EOF
https://cdn.joypixels.com/arch-linux/font/${version}/joypixels-android.ttf
  dir=$FONTS_DIR
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
elif [ "$VERSION_ID" = "20.04" ]; then
  post_install << "POST_INSTALL_EOF"
sudo patch -d /etc/fonts -p 1 -r - -N << "EOF"
diff -Naur fonts/conf.avail/45-generic.conf fonts-patched/conf.avail/45-generic.conf
--- fonts/conf.avail/45-generic.conf	2022-07-20 11:27:31.954131395 -0700
+++ fonts-patched/conf.avail/45-generic.conf	2022-07-20 11:28:12.574376298 -0700
@@ -34,6 +34,10 @@
 	</alias>
 	<!-- Third-party emoji -->
 	<alias binding="same">
+		<family>JoyPixels</family>
+		<default><family>emoji</family></default>
+	</alias>
+	<alias binding="same">
 		<family>Emoji Two</family>
 		<default><family>emoji</family></default>
 	</alias>
diff -Naur fonts/conf.avail/60-generic.conf fonts-patched/conf.avail/60-generic.conf
--- fonts/conf.avail/60-generic.conf	2022-07-20 11:27:31.954131395 -0700
+++ fonts-patched/conf.avail/60-generic.conf	2022-07-20 11:28:39.394447502 -0700
@@ -41,6 +41,7 @@
 			<family>Twitter Color Emoji</family> <!-- Twitter -->
 			<family>EmojiOne Mozilla</family> <!-- Mozilla -->
 			<!-- Third-Party fonts -->
+			<family>JoyPixels</family>
 			<family>Emoji Two</family>
 			<family>Emoji One</family>
 			<!-- Non-color -->
EOF
POST_INSTALL_EOF
fi

fc_cache

finalize
