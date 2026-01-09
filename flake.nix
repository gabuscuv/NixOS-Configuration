{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs"; # Follows stable nixpkgs by default
    };

    nixos-hardware = {
      url = "github:gabuscuv/nixos-hardware/15ahp10";
    };

    ## Rocksmith 2014 WineASIO / pipewire
    # A flake providing necessary module `programs.steam.rocksmithPatch`
    nixos-rocksmith = {
      url = "github:re1n0/nixos-rocksmith";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nur,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      };
      mkHost =
        {
          hostModules,
          extraModules ? [ ],
          extraSpecialArgs ? { },
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
          }
          // extraSpecialArgs;
          modules = [
            { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
            inputs.nixos-rocksmith.nixosModules.default
            home-manager.nixosModules.home-manager

            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.gabuscuv = import ./home.nix;
            }

            ./configuration.nix
          ]
          ++ hostModules
          ++ extraModules;
        };
    in
    {
      nixosConfigurations = {
        generic-libvirt = mkHost {
          hostModules = [ ./hosts/generic-libvirt ];
        };

        Victoriqu3 = mkHost {
          hostModules = [
            inputs.nixos-hardware.nixosModules.lenovo-legion-15ahp10-oled
            ./hosts/laptop
          ];
        };

        shironeko = mkHost {
          hostModules = [ ./hosts/shironeko ];
        };
        verlays = [
          inputs.nur.overlay
        ];

        rory = mkHost {
          hostModules = [ ./hosts/rory ];
        };

      };
      devShells.${system} = nixpkgs.lib.mapAttrs (_: path: import path { inherit pkgs; }) {
        unreal = ./shells/unreal.nix;
        godot = ./shells/godot.nix;
        unity = ./shells/unity.nix;
        unity6 = ./shells/unity6.nix;
        android = ./shells/android.nix;
        cpp = ./shells/cpp.nix;
        node = ./shells/node.nix;
      };
    };
}
