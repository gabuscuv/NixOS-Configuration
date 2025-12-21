#!/bin/sh

ROOTHEAD=/tmp/config
NIX_DIRECTORY=$ROOTHEAD/etc/nixos

nixos-generate-config --root $ROOTHEAD --no-filesystems

rsync -rvP $PWD/* $NIX_DIRECTORY

HOSTNAMES="shironeko rory victoriqu3 generic-libvirt"

for HOST in ${HOSTNAMES}; do
    echo ${HOST};
done

#do
read -p "Enter the hostname to install: " SELECTED_HOST
#done while ! echo "${HOSTNAMES}" | grep -qw "${SELECTED_HOST}"
echo "Installing NixOS for host: ${SELECTED_HOST}"
## TODO Make a Disk selector
sudo nix --experimental-features "nix-command flakes" \
  run 'github:nix-community/disko/latest#disko-install' -- \
  --flake "$NIX_DIRECTORY/stage1-bootstrap/#${SELECTED_HOST}" --disk main /dev/vda


