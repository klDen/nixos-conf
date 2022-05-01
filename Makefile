all:
	nixos-rebuild switch --use-remote-sudo --flake .

update:
	nix flake lock --update-input home-manager
	nix flake lock --update-input nixpkgs

