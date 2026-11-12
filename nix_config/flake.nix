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
    {
      nixosConfigurations.BonDia = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          hostName = "BonDia";
          userName = "alba";
          videoDriver = "nvidia";
        };

        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
          ./nixos-config-parts/map-disks.nix
          ./nixos-config-parts/nvidia.nix
          home-manager.nixosModules.home-manager

          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {
                hostName = "BonDia";
                userName = "alba";
              };

              users.alba = import ./home.nix;
              backupFileExtension = "backup";
            };
          }
        ];
      };
    };
}
