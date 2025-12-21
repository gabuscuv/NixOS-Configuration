#!/bin/sh
set -e
## STAGE 1 for Low Memory NixOS Installations
ROOTHEAD=/tmp/config
NIX_DIRECTORY=$ROOTHEAD/etc/nixos
STAGE1_DIR=$NIX_DIRECTORY/stage1-bootstrap

nixos-generate-config --root $ROOTHEAD --no-filesystems

rsync -rvP $PWD/* $NIX_DIRECTORY
cp $NIX_DIRECTORY/hardware-configuration.nix $STAGE1_DIR
rsync -rvP $NIX_DIRECTORY/hosts $STAGE1_DIR

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
  --flake "$STAGE1_DIR#${SELECTED_HOST}" --disk main /dev/$DEVICE_NAME
