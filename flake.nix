{
  description = "klden's NixOS config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixos-hardware.url = github:NixOS/nixos-hardware/master;
    home-manager.url = github:nix-community/home-manager;
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-wayland.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, home-manager, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { 
        inherit system; 
        config.allowUnfree = true;
        nixpkgs.overlays = [
          inputs.nixpkgs-wayland.overlay
        ];
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
          ./features/caches
          ./features/default.nix
          ./features/networkmanager-iwd.nix
          #./features/connman-iwd.nix
          ./features/light.nix
          ./features/adb.nix
          ./features/docker.nix
          #./features/podman.nix
          ./features/slack.nix
          ./features/signal-desktop.nix
          ./features/java.nix
          ./features/retext.nix
          ./features/gnupg.nix
          ./features/libvirt.nix
          #./features/virtualbox.nix

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
            ./features/broadcom_sta.nix
          ];
        x1e3 = mkHomeMachine
          ./hosts/x1e3.nix
          [
            ./features/openvpn.nix
            ./features/beyond-identity.nix
            ./features/globalprotect.nix
            ./features/falcon.nix
            ./features/google-cloud.nix
            ./features/poetry.nix
            ./features/python.nix
            ./features/pipenv.nix
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
            #./features/jetbrains/enterprise/datagrip.nix
            ./features/jetbrains/enterprise/pycharm.nix
            #./features/jetbrains/enterprise/webstorm.nix
            ./features/jetbrains/enterprise/goland.nix
            ./features/go.nix
          ];
      };
    };
}

