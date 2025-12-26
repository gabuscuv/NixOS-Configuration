#!/bin/sh
DEVICE_NAME= ${DEVICE_NAME:-"vda"}
SELECTED_HOST=${SELECTED_HOST:-"generic-libvirt"}

echo "NixOS installation for host ${SELECTED_HOST} completed."
mkdir -p /mnt/nixos
mount /dev/${DEVICE_NAME}2 -o subvol=@ /mnt/nixos
mount /dev/${DEVICE_NAME}2 -o subvol=@home /mnt/nixos/home
mount /dev/${DEVICE_NAME}2 -o subvol=@log /mnt/nixos/var/log
mount /dev/${DEVICE_NAME}2 -o subvol=@snapshots /mnt/nixos/.snapshots
mount /dev/${DEVICE_NAME}2 -o subvol=@nix /mnt/nixos/nix
mount /dev/${DEVICE_NAME}1 /mnt/nixos/boot
