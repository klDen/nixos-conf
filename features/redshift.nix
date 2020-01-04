{ config, pkgs, ...}:
# Based on https://nixos.wiki/wiki/Redshift
{
  services.redshift = {
    enable = true;
    temperature = {
      day = 4000;
      night = 1900;
    };
  };
}

