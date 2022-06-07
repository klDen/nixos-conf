ARGS?=

all:
	nixos-rebuild switch --use-remote-sudo --flake . $(ARGS)

update:
	nix flake lock --update-input home-manager
	nix flake lock --update-input nixpkgs

