{ lib, ... }:
{
  disko.devices = {
    disk = {
      x = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "64M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            zfs = {
              size = "100%";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          };
        };
      };
    };
    zpool = {
      zroot = {
        type = "zpool";
        rootFsOptions = {
          compression = "zstd";
          "com.sun:auto-snapshot" = "false";
              mountpoint = "none";
              # encryption = "aes-256-gcm";
              # keyformat = "passphrase";
              # keylocation = "file:///tmp/secret.key";
        };
        postCreateHook = "zfs snapshot rpool@blank";

        datasets = {
          root = {
            type = "zfs_fs";
            options.mountpoint = "none";
            # options."com.sun:auto-snapshot" = "true";
          };
          "root/nixos" = {
            type = "zfs_fs";
            options.mountpoint = "legacy";
            mountpoint = "/";
          };
          home = {
            mountpoint = "/home";
            type = "zfs_fs";
            options.mountpoint = "legacy";
            options."com.sun:auto-snapshot" = "true";
            options.compression = "lz4";
          };
        };
      };
    };
  };
}


