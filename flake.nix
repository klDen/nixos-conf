{
  description = "klden's NixOS config";

  inputs = {
    #nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      # Make configuration for any computer I use in my home office.
      mkHomeMachine = configurationNix: extraModules: nixpkgs.lib.nixosSystem {
        inherit system;
        # Arguments to pass to all modules.
        specialArgs = { inherit system inputs; };
        modules = ([
          # System configuration
          configurationNix

          # Features common to all of my machines
          ./features/current-location.nix
          ./features/gnupg.nix
          ./features/docker.nix
          ./features/fonts.nix
          ./features/redshift.nix
          ./features/connman-iwd.nix
          ./features/i3
          ./features/default.nix
          ./features/light.nix
          ./features/latex.nix

          # home-manager configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.klden = import ./home.nix {
              inherit inputs system;
              pkgs = import nixpkgs { inherit system; };
            };
          }
        ] ++ extraModules);
      };
    in
    {
      nixosConfigurations.desktop = mkHomeMachine
        ./hosts/desktop.nix
        [
          ./features/virtualbox.nix
          ./features/adb.nix
          ./features/jetbrains/community/intellij.nix
        ];
      nixosConfigurations.x1e3 = mkHomeMachine
        ./hosts/x1e3.nix
        [
        ];
    };
}
