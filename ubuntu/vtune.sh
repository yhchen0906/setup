#! /bin/sh
if [ -z "$HEADER_INCLUDED" ]; then
  eval "$(wget -qO- https://setup.rogeric.xyz/ubuntu/header.sh)"
fi

initialize

add_apt_key 'https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB'
add_apt_list oneAPI 'deb https://apt.repos.intel.com/oneapi all main'

apt_install intel-oneapi-vtune

finalize
