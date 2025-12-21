ROOTHEAD=/mnt/nixos
NIX_DIRECTORY=$ROOTHEAD/etc/nixos

rsync -rvP $PWD/* $NIX_DIRECTORY

nixos-generate-config --root $ROOTHEAD
nixos-install --root /mnt/nixos --flake $NIX_DIRECTORY#${SELECTED_HOST} --option accept-flake-config true
