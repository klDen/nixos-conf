{ config, pkgs, ... }:
{
  services = {
    xserver = {
      enable = true;
      displayManager.defaultSession = "none+i3";
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        configFile = ./i3-klden/config;
        extraPackages = with pkgs; [
          scrot
          volumeicon
          dmenu #application launcher most people use
          i3status
          i3-gaps
          i3lock-fancy
          flameshot
          caffeine-ng
        ];
      };
    };
  };

  services = {
    redshift = {
      enable = true;
      provider = "manual";
      longitude = -73.59;
      latitude = 45.53;
      temperature = {
        day = 4000;
        night = 1900;
      };
    };
    udev = {
     # autoswitch to proper autorandr display profile
     extraRules = ''
       ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.stdenv.shell} -c '${pkgs.autorandr}/bin/autorandr --batch --change --default default'"
    '';
  };
}
