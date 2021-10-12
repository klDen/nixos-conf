{ config, pkgs, ... }:
{
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # so that gtk works properly
    extraPackages = with pkgs; [
      swaylock-effects
      swayidle
      xorg.xlsclients
      wl-clipboard
      mako # notification daemon
      foot
      wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
      xwayland # for legacy apps
      waybar # status bar
      kanshi # autorandr
      gammastep # redshift for wayland
      swappy grim slurp
      flashfocus

      libappindicator-gtk3 gnomeExtensions.appindicator
    ];
    # https://github.com/flameshot-org/flameshot/blob/master/docs/Sway%20and%20wlroots%20support.md#sway-and-wlroots-support
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
    '';

      #export MOZ_USE_XINPUT2=1
      #export QT_QPA_PLATFORM=wayland
      #export XDG_SESSION_TYPE=wayland
      #export XDG_CURRENT_DESKTOP=sway
      #export SDL_VIDEODRIVER=wayland
  };

  environment = {
    etc = {
      # Put config files in /etc. Note that you also can put these in ~/.config, but then you can't manage them with NixOS anymore!
      "sway/config".source = ./config;
      "xdg/waybar/config".source = ./waybar/config;
      "xdg/waybar/style.css".source = ./waybar/style.css;
      "kanshi/config".source = ./kanshi/config;
      "xdg/swappy/config".source = ./swappy/config;
    };
    sessionVariables = rec {
      XDG_CONFIG_HOME = "/etc/xdg";
    };
  };

  fonts.fonts = with pkgs; [
    font-awesome # for waybar 
  ];

  #services = {
  #  udev = {
  #    # autoswitch to proper autorandr display profile
  #    extraRules = ''
  #      ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.stdenv.shell} -c '${pkgs.kanshi}/bin/kanshi --config /etc/kanshi/config'"
  #    '';
  #  };
  #}; 
}

