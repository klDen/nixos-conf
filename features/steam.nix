{ lib, pkgs, ... }:
{
  hardware.opengl.extraPackages = with pkgs; [ libva ];
  programs.steam.enable = true;
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam"
    "steam-original"
    "steam-runtime"
  ];
}

