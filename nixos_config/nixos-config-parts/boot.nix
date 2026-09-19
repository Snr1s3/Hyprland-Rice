{ ... }:

{
	boot.loader.systemd-boot = {
        enable = true;
        configurationLimit = 3;

        extraEntries = {
        "windows.conf" = ''
            title Windows
            efi /EFI/Microsoft/Boot/bootmgfw.efi
        '';
        };
    };

    boot.loader.efi.canTouchEfiVariables = true;
}