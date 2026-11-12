{ ... }:

{
  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/88A43A08A439F8F0";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };

  fileSystems."/mnt/Tot" = {
    device = "/dev/disk/by-uuid/7C604DC5604D86BC";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "umask=022"
    ];
  };
}