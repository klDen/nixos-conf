{ pkgs, ... }: {
  imports = [
    ./nixpkgs.nix
    ./nixpkgs-wayland.nix
  ];
}

