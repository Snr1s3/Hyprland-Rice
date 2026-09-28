{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nixos-config-parts/boot.nix
    ./nixos-config-parts/networking.nix
    ./nixos-config-parts/bluetooth.nix
    ./nixos-config-parts/locale.nix
    ./nixos-config-parts/security.nix
    ./nixos-config-parts/user.nix
    ./nixos-config-parts/desktop.nix
    ./nixos-config-parts/nvidia.nix
    ./nixos-config-parts/packages.nix
    ./nixos-config-parts/services.nix
    ./nixos-config-parts/gaming.nix
    ./nixos-config-parts/nix.nix
    ./nixos-config-parts/overlays.nix
  ];

  # ============================================================================
  # System version
  # ============================================================================

  system.stateVersion = "26.05";
}
