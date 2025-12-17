{
  
  inputs = {
  
    nixos-hardware.url = "github:gabuscuv/nixos-hardware/15ahp10-oled";
    
    ## Rocksmith 2014 WineASIO / pipewire
    # A flake providing necessary module `programs.steam.rocksmithPatch`
    nixos-rocksmith = {
      url = "github:re1n0/nixos-rocksmith";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }

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
          inputs.nixos-rocksmith.nixosModules.default
          ./configuration.nix
          nixos-hardware.nixosModules.lenovo-legion-15ahp10-oled
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
            inputs.nixos-rocksmith.nixosModules.default
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
            inputs.nixos-rocksmith.nixosModules.default
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
    devShells.${system} = {
      unreal  = import ./shells/unreal.nix  { inherit pkgs; };
      godot   = import ./shells/godot.nix   { inherit pkgs; };
      unity   = import ./shells/unity.nix   { inherit pkgs; };
      android = import ./shells/android.nix { inherit pkgs; };
    };
  };
}
