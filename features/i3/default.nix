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
          dmenu #application launcher most people use
          i3status
          i3-gaps
          i3lock-fancy
          rofi
        ];
      };
    };
  };
}
