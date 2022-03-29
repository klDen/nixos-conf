{ pkgs, ... }: {
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.binaryCaches = [
    "https://cache.nixos.org"
  ];
}


