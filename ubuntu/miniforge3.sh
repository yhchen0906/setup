#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh
  dir=$TMP_DIR
  out=miniforge3.sh
EOF

post_install << "POST_INSTALL_EOF"
chmod a+x "$TMP_DIR/miniforge3.sh"

PREFIX=$OPT_DIR/miniforge3
"$TMP_DIR/miniforge3.sh" -u -b -p "$PREFIX"

MAMBA=$PREFIX/bin/mamba
"$MAMBA" update -y mamba
POST_INSTALL_EOF

finalize
