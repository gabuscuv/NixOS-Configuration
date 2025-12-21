#!/bin/sh

nixos-generate-config --root /tmp/config --no-filesystems

rsync -rvP $PWD/* /tmp/config/etc/nixos/

HOSTNAMES="shironeko rory victoriqu3 generic-libvirt"

for HOST in ${HOSTNAMES}; do
    echo ${HOST};
done

do
read -p "Enter the hostname to install: " SELECTED_HOST
done while ! echo "${HOSTNAMES}" | grep -qw "${SELECTED_HOST}"

nix --experimental-features "nix-command flakes" \
  run github:nix-community/disko \
  -- --mode disko ./disko.nix
###
##sudo nix run github:nix-community/disko \
##  -- --mode disko ./hosts/gamejam-laptop/disks.nix

## TODO Make a Disk selector
sudo nixos-install --flake .#${SELECTED_HOST} --disk main /dev/vda --show-trace