#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

aria2_download << EOF
https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
  dir=$TMP_DIR
  out=miniconda.sh
EOF

post_install << "POST_INSTALL_EOF"
chmod a+x "$TMP_DIR/miniconda.sh"

PREFIX=$OPT_DIR/miniconda3
"$TMP_DIR/miniconda.sh" -u -b -p "$PREFIX"

CONDA=$PREFIX/bin/conda
"$CONDA" config --set always_yes True
"$CONDA" config --add create_default_packages 'autopep8'
"$CONDA" config --add create_default_packages 'pylint'
"$CONDA" config --add create_default_packages 'python'
"$CONDA" update --all
POST_INSTALL_EOF

finalize
