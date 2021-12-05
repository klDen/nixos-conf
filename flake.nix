{
  description = "klden's NixOS config";

  inputs = {
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { 
        inherit system; 
        config.allowUnfree = true;
      };
      mkHomeMachine = configurationNix: extraModules: nixpkgs.lib.nixosSystem {
        inherit system pkgs;
        # Arguments to pass to all modules.
        specialArgs = { inherit system inputs; };
        modules = ([
          # System configuration
          configurationNix

          # Features common to all of my machines
          #./features/i3
          ./features/sway
          ./features/default.nix
          ./features/connman-iwd.nix
          ./features/light.nix
          ./features/adb.nix
          ./features/docker.nix
          ./features/podman.nix
          ./features/slack.nix
          ./features/signal-desktop.nix
          ./features/virtualbox.nix
          ./features/java.nix

          # home-manager configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.klden = import ./home.nix {
              inherit inputs system pkgs;
            };
          }
        ] ++ extraModules);
      };
    in
    {
      nixosConfigurations = {
        desktop = mkHomeMachine
          ./hosts/desktop.nix
          [
            ./features/jetbrains/community/intellij.nix
            ./features/wireshark.nix
          ];
        x1e3 = mkHomeMachine
          ./hosts/x1e3.nix
          [
            ./features/openvpn.nix
            ./features/beyond-identity.nix
            ./features/globalprotect.nix
            ./features/google-cloud.nix
            ./features/poetry.nix
            ./features/python.nix
            ./features/terraform.nix
            ./features/vault.nix
            ./features/helm.nix
            ./features/scala.nix
            ./features/chart-testing.nix
            ./features/yamale.nix
            ./features/yamllint.nix
            ./features/kind.nix
            #./features/zoom.nix

            ./features/jetbrains/enterprise/intellij.nix
            ./features/jetbrains/enterprise/datagrip.nix
            ./features/jetbrains/enterprise/pycharm.nix
            ./features/jetbrains/enterprise/webstorm.nix
            ./features/jetbrains/enterprise/goland.nix
          ];
      };
    };
}

