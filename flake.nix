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

    nur.url = "github:nix-community/NUR";
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
        overlays = [
          inputs.nur.overlay
        ];
      };
    in
    {
      nixosConfigurations.generic-libvirt = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
          inputs.nixos-rocksmith.nixosModules.default
          ./configuration.nix
          ./hosts/generic-libvirt
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gabuscuv = import ./home.nix;
          }
        ];
      };
      nixosConfigurations.Victoriqu3 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
          inputs.nixos-rocksmith.nixosModules.default
          ./configuration.nix
          inputs.nixos-hardware.nixosModules.lenovo-legion-15ahp10-oled
          ./hosts/laptop
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.gabuscuv = import ./home.nix;
          }
        ];
      };
      nixosConfigurations.shironeko = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
          inputs.nixos-rocksmith.nixosModules.default
          ./configuration.nix
          ./hosts/shironeko
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            nixpkgs.overlays = [ nur.overlay ];
            home-manager.users.gabuscuv = import ./home.nix;
          }
        ];
      };
      nixosConfigurations.rory = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          { nixpkgs.overlays = [ inputs.nur.overlays.default ]; }
          inputs.nixos-rocksmith.nixosModules.default
          ./configuration.nix
          ./hosts/rory
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit nur; };
            home-manager.users.gabuscuv = import ./home.nix;
          }
        ];
      };
      devShells.${system} = {
        unreal = import ./shells/unreal.nix { inherit pkgs; };
        godot = import ./shells/godot.nix { inherit pkgs; };
        unity = import ./shells/unity.nix { inherit pkgs; };
        unity6 = import ./shells/unity6.nix { inherit pkgs; };
        android = import ./shells/android.nix { inherit pkgs; };
        cpp = import ./shells/cpp.nix { inherit pkgs; };
        node = import ./shells/node.nix { inherit pkgs; };
      };
    };
}
