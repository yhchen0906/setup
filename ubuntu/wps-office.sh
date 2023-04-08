#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

DOWNLOAD_URL='https://wdl1.pcfg.cache.wpscdn.com/wpsdl/wpsoffice/download/linux/11691/wps-office_11.1.0.11691.XA_amd64.deb'

aria2_download << EOF
$DOWNLOAD_URL
  dir=$TMP_DIR
  out=wps-office.deb
https://github.com/IamDH4/ttf-wps-fonts/archive/master.tar.gz
  dir=$TMP_DIR
  out=ttf-wps-fonts.tar.gz
EOF

apt_install "$TMP_DIR/wps-office.deb"

post_install << "POST_INSTALL_EOF"
EXTRACT_DIR=$(mktemp -d -p "$TMP_DIR")
tar zxf "$TMP_DIR/ttf-wps-fonts.tar.gz" -C "$EXTRACT_DIR"
sudo mkdir -p /usr/share/fonts/wps-office
find "$EXTRACT_DIR" -iname '*.ttf' | xargs -t sudo cp -t /usr/share/fonts/wps-office

sudo rm -rf /root/模板 /etc/skel/模板
rm -f \
  ~/Templates/DOC\ 文档.doc \
  ~/Templates/DOCX\ 文档.docx \
  ~/Templates/XLS\ 工作表.xls \
  ~/Templates/XLSX\ 工作表.xlsx \
  ~/Templates/PPT\ 演示文稿.ppt \
  ~/Templates/PPTX\ 演示文稿.pptx \
  ~/Desktop/wps-office-prometheus.desktop
POST_INSTALL_EOF

fc_cache

finalize
