all:
	sudo nixos-rebuild switch --flake .

update:
	sudo nix flake lock --update-input home-manager
	sudo nix flake lock --update-input nixpkgs

