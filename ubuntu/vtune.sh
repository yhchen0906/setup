#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

DOWNLOAD_URL='https://registrationcenter-download.intel.com/akdlm/irc_nas/tec/17095/vtune_profiler_2020.tar.gz'

aria2_download << EOF
https://registrationcenter-download.intel.com/akdlm/irc_nas/tec/17095/vtune_profiler_2020.tar.gz
  dir=$TMP_DIR
  out=vtune.tar.gz
EOF

post_install << "POST_INSTALL_EOF"
EXTRACT_DIR=$(mktemp -d -p "$TMP_DIR")
tar zxf "$TMP_DIR/vtune.tar.gz" -C "$EXTRACT_DIR"
POST_INSTALL_EOF

finalize
