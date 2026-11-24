{
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 20;
  };

  boot.loader.efi.canTouchEfiVariables = true;
}
