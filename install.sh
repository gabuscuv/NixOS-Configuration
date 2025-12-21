#!/bin/sh

nixos-generate-config --root /tmp/config --no-filesystems

rsync -rvP $PWD/* /tmp/config/etc/nixos/

HOSTNAMES="shironeko rory victoriqu3 generic-libvirt"

for HOST in ${HOSTNAMES}; do
    echo ${HOST};
done

#do
read -p "Enter the hostname to install: " SELECTED_HOST
#done while ! echo "${HOSTNAMES}" | grep -qw "${SELECTED_HOST}"
echo "Installing NixOS for host: ${SELECTED_HOST}"
## TODO Make a Disk selector
nix --experimental-features "nix-command flakes" \
  run 'github:nix-community/disko/latest#disko-install' \
  -- --flake /tmp/config/etc/nixos/#${SELECTED_HOST} --disk main /dev/vda