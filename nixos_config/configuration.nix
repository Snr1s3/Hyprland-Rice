{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./config-parts/map-disks.nix
    ./config-parts/boot.nix
    ./config-parts/networking.nix
    ./config-parts/bluetooth.nix
    ./config-parts/locale.nix
    ./config-parts/security.nix
    ./config-parts/user.nix
    ./config-parts/desktop.nix
    ./config-parts/nvidia.nix
    ./config-parts/packages.nix
    ./config-parts/services.nix
    ./config-parts/gaming.nix
    ./config-parts/nix.nix
    ./config-parts/overlays.nix
  ];

  # ============================================================================
  # System version
  # ============================================================================

  system.stateVersion = "26.05";
}
