{
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  inputs.disko.url = "github:nix-community/disko/latest";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { self, disko, nixpkgs }: {
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in {
      nixosConfigurations.generic-libvirt =
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {inherit inputs;};
          modules = [
            ../configuration.nix
            ../hosts/generic-libvirt/disk.nix
            ../disko.nix
            disko.nixosModules.disko
          ];
        };
      nixosConfigurations.laptop =
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ../configuration.nix
            ../hosts/generic-libvirt/disk.nix
            ../disko.nix
            disko.nixosModules.disko
          ];
        };
        nixosConfigurations.shironeko =
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ../configuration.nix
              ../hosts/shironeko/diskio.nix
              disko.nixosModules.disko
            ];
          };
        nixosConfigurations.rory =
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ../configuration.nix
              ../disko.nix
              ../hosts/rory/disk.nix
              disko.nixosModules.disko

            ];
          };
    };
  }
}
