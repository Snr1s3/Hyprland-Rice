{ ... }:

{
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 20; # optional, keeps /boot from filling up
  };

  boot.loader.efi.canTouchEfiVariables = true;
}