{ ... }:

{
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 5;
  };

  boot.loader.efi.canTouchEfiVariables = true;
}