#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

LLVM_VERSION=13

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

finalize
