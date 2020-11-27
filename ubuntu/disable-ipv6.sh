#! /bin/sh
NEW_CMDLINE=$( (sed -nE 's;^GRUB_CMDLINE_LINUX_DEFAULT="(.*)"$;\1;p' /etc/default/grub | tr ' ' '\n' | grep -v -F "ipv6.disable=1" ; echo -n "ipv6.disable=1") | tr '\n' ' ')
echo $NEW_CMDLINE
