{ hostName, ... }:

{
	networking = {
        hostName = hostName;

        networkmanager.enable = true;
        wireless.enable = true;
    };
}