{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    extraConfig = ''
      set theme=/boot/grub/themes/fallout-grub-theme/theme.txt
    '';
  };

  boot.loader.efi.canTouchEfiVariables = true;
}
