#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.yeeha.xyz/ubuntu/header.sh)"
fi

initialize

if [ "$VERSION_ID" = "18.04" ]; then
add_apt_key 'https://apt.llvm.org/llvm-snapshot.gpg.key'
add_apt_list llvm \
  "deb http://apt.llvm.org/$UBUNTU_CODENAME/ llvm-toolchain-$UBUNTU_CODENAME main"
fi

apt_install \
  lld \
  lldb \
  clang \
  clangd \
  clang-tidy \
  clang-format

finalize
