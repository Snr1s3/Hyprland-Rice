{ ... }:

{
  imports = [
    ./nixos-config-parts/boot.nix
    ./nixos-config-parts/bluetooth.nix
    ./nixos-config-parts/desktop.nix
    ./nixos-config-parts/gaming.nix
    ./nixos-config-parts/locale.nix
    ./nixos-config-parts/map-disks.nix
    ./nixos-config-parts/networking.nix
    ./nixos-config-parts/nix.nix
    ./nixos-config-parts/nvidia.nix
    ./nixos-config-parts/overlays.nix
    ./nixos-config-parts/packages.nix
    ./nixos-config-parts/security.nix
    ./nixos-config-parts/services.nix
    ./nixos-config-parts/user.nix
  ];

  # ============================================================================
  # System version
  # ============================================================================
  programs.nix-ld.enable = true;
  system.stateVersion = "26.05";
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.enable = false;  # older releases: hardware.pulseaudio.enable = false
}
