{ ... }:

{
	fileSystems."/mnt/Games" = {
		device = "/dev/disk/by-uuid/88A43A08A439F8F0";
		fsType = "ntfs";
	};

	fileSystems."/mnt/Disk1" = {
		device = "/dev/disk/by-uuid/D840556740554D7E";
		fsType = "ntfs";
	};

	fileSystems."/mnt/Tot" = {
		device = "/dev/disk/by-uuid/7C604DC5604D86BC";
		fsType = "ntfs";
	};
}
