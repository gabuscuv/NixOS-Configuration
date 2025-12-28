{ lib, ... }:

{
  disko.devices = {

    ####################
    # NVMe (system disk)
    ####################
    disk.nvme0n1 = {
      type = "disk";
      device = "/dev/nvme0n1";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            size = "256M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };

          lvm = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "vg-main";
            };
          };
        };
      };
    };

    lvm_vg.vg-main = {
      type = "lvm_vg";
      lvs = {
        main-root = {
          size = "113.2G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/";
          };
        };

        main-var = {
          size = "24G";
          content = {
            type = "filesystem";
            format = "ext4";
            mountpoint = "/var";
          };
        };

        main-vms = {
          size = "226.3G";
          content = {
            type = "filesystem";
            mountpoint = "/var/lib/libvirt/images";
            # CRITICAL: do NOT format
            format = null;
            preserve = true;
          };
        };
      };
    };

    ####################
    # sda – third disk
    ####################
    disk.sda = {
      type = "disk";
      device = "/dev/sda";
      content = {
        type = "gpt";
        partitions = {
          lvm = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "vg-third";
            };
          };
        };
      };
    };

    lvm_vg.vg-third = {
      type = "lvm_vg";
      lvs = {
        third-vms = {
          size = "512G";
          content = {
            type = "filesystem";
            mountpoint = "/home/gabuscuv/.virt/Projects";
            # CRITICAL: do NOT format
            format = null;
            preserve = true;
          };
        };

        third-home = {
          size = "100%FREE";
          content = {
            type = "filesystem";
            mountpoint = "/home";
            # CRITICAL: do NOT format
            format = null;
            preserve = true;
          };
        };
      };
    };

    ####################
    # sdb – second disk
    ####################
    disk.sdb = {
      type = "disk";
      device = "/dev/sdb";
      content = {
        type = "gpt";
        partitions = {
          lvm = {
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "vg-second";
            };
          };
        };
      };
    };

    lvm_vg.vg-second = {
      type = "lvm_vg";
      lvs = {
        second-home = {
          size = "100%FREE";
          content = {
            type = "filesystem";
            mountpoint = "/home-overlay";
            # CRITICAL: do NOT format
            format = null;
            preserve = true;
          };
        };
      };
    };
  };
}
