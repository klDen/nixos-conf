{ config, pkgs, ... }:
{
  environment = {
    etc = {
      "xdg/autorandr".source = ./autorandr;
    };
  };

  location = {
    provider = "manual";
    longitude = -73.59;
    latitude = 45.53;
  };

  services = {
    xserver = {
      enable = true;

      displayManager = {
        gdm.enable = true;
        defaultSession = "none+i3";
      };
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        configFile = ./config;
        extraPackages = with pkgs; [
          flameshot scrot
          volumeicon
          dmenu #application launcher most people use
          i3status
          i3-gaps
          i3lock-fancy
          caffeine-ng
          xidlehook
          autorandr arandr
          autocutsel
          rxvt-unicode
          firefox-bin
          chromium
        ];
      };
    };

    redshift = {
      enable = true;
      temperature = {
        day = 4000;
        night = 1900;
      };
    };

    xserver.displayManager.sessionCommands = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge <<EOF
        URxvt.scrollBar: 	false
        URxvt.background:       black
        URxvt.foreground: 	white
        URxvt.boldFont:
        URxvt.font: 		xft:monoid:size=15
        URxvt.letterSpace: 	-2 
        URxvt.perl-ext-common:  clipboard,selection-to-clipboard
        URxvt.color3:           DarkGoldenrod
        URxvt.color4:           RoyalBlue
        URxvt.color7:           gray75
        URxvt.color11:          LightGoldenrod
        URxvt.color12:          LightSteelBlue
        URxvt.colorBD:          #ffffff
        URxvt.colorUL:          LightSlateGrey
        URxvt.colorIT:          SteelBlue
        URxvt.cursorColor:      grey90
        URxvt.highlightColor:   grey25
        URxvt.iso14755: 	false
        URxvt.iso14755_52: 	false
      EOF
    '';

    # autoswitch to proper autorandr display profile
    udev.extraRules = ''
      ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.stdenv.shell} -c '${pkgs.autorandr}/bin/autorandr --batch --change --default default'"
    '';
  };

  hardware = {
    pulseaudio = {
      package = pkgs.pulseaudioFull;
      enable = true;
     #  extraConfig = "set-default-source alsa_input.usb-Blue_Microphones_Yeti_X_2052SG005LJ8_888-000313110306-00.analog-stereo\nset-default-sink alsa_output.pci-0000_0a_00.1.hdmi-stereo";
    };
  };
}

