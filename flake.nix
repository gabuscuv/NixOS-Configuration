{
  outputs = { self, nixpkgs, home-manager, disko, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations.generic-libvirt =
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./hosts/generic-libvirt
          ./disko.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gabuscuv = import ./home.nix;
          }
        ];
      };
    nixosConfigurations.laptop =
      nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          ./hosts/laptop
          ./disko.nix
          disko.nixosModules.disko
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gabuscuv = import ./home.nix;
          }
        ];
      };
      nixosConfigurations.shironeko =
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./hosts/shironeko
            ./disko.nix
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gabuscuv = import ./home.nix;
            }
          ];
        };
      nixosConfigurations.rory =
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            ./configuration.nix
            ./hosts/rory
            ./disko.nix
            disko.nixosModules.disko
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gabuscuv = import ./home.nix;
            }
          ];
        };
  };

  devShells.${system} = {
    unreal  = import ./shells/unreal.nix  { inherit pkgs; };
    godot   = import ./shells/godot.nix   { inherit pkgs; };
    unity   = import ./shells/unity.nix   { inherit pkgs; };
    android = import ./shells/android.nix { inherit pkgs; };
  };
}
