#!/bin/sh

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

sudo nixos-install --flake .#${SELECTED_HOST} --show-trace