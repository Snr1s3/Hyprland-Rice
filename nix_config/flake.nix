{
  description = "Hyprland on NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-grub-themes = {
      url = "github:jeslie0/nixos-grub-themes";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, ... }:
    let
      mkHost = { hostName, userName, videoDriver ? null, hostModules }:
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs hostName userName videoDriver; };

          modules = hostModules ++ [
            home-manager.nixosModules.home-manager

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit hostName userName; };

                users.${userName} = import ./home.nix;
                backupFileExtension = "backup";
              };
            }
          ];
        };
    in
    {
      nixosConfigurations.BonDia = mkHost {
        hostName = "BonDia";
        userName = "alba";
        videoDriver = "nvidia";
        hostModules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./nixos-config-parts/map-disks.nix
          ./nixos-config-parts/nvidia.nix
        ];
      };
    };
}
