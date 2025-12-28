{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
  inputs.disko.url = "github:nix-community/disko/latest";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    {
      self,
      disko,
      nixpkgs,
    }:
    {
      nixosConfigurations.generic-libvirt = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          disko.nixosModules.disko
          ./hosts/generic-libvirt/disk.nix
          ./disko.nix
        ];
      };
      nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          disko.nixosModules.disko
          ./hosts/generic-libvirt/disk.nix
          ./disko.nix
        ];
      };
      nixosConfigurations.shironeko = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          ./hosts/shironeko/diskio.nix
          disko.nixosModules.disko
        ];
      };
      nixosConfigurations.rory = nixpkgs.lib.nixosSystem {
        modules = [
          ./configuration.nix
          disko.nixosModules.disko
          ./hosts/rory/disk.nix
          ./disko.nix
        ];
      };
    };
}
