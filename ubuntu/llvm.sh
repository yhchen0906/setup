#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

LLVM_VERSION=15

add_apt_key 'https://apt.llvm.org/llvm-snapshot.gpg.key'
add_apt_list llvm \
  "deb http://apt.llvm.org/$UBUNTU_CODENAME/ llvm-toolchain-$UBUNTU_CODENAME-$LLVM_VERSION main"

apt_install \
  lld-$LLVM_VERSION \
  lldb-$LLVM_VERSION \
  clang-$LLVM_VERSION \
  clangd-$LLVM_VERSION \
  clang-tidy-$LLVM_VERSION \
  clang-tools-$LLVM_VERSION \
  clang-format-$LLVM_VERSION

post_install << POST_INSTALL_EOF
LLVM_VERSION=$LLVM_VERSION
POST_INSTALL_EOF

post_install << "POST_INSTALL_EOF"
cd /usr/bin || exit
find . -mindepth 1 -maxdepth 1 \
  -name "*clang*-$LLVM_VERSION*" \( -type f -o -type l \) \
  -printf '%f\n' | awk -v version=$LLVM_VERSION '{
    printf "ln -sf %s ", $0;
    gsub("-"version, "");
    print $0;
  }' | sudo sh -x
cd - > /dev/null || exit
POST_INSTALL_EOF

finalize
