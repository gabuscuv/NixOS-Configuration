{ ... }:
{
  disko.devices.disk.main = {
    type = "disk";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };

        root = {
          size = "100%";
          content = {
            type = "btrfs";
            subvolumes = {
              "@" = { mountpoint = "/"; };
              "@home" = { mountpoint = "/home"; };
              "@nix" = { mountpoint = "/nix"; };
              "@log" = { mountpoint = "/var/log"; };
              "@snapshots" = { mountpoint = "/.snapshots"; };
            };
          };
        };
      };
    };
  };
}