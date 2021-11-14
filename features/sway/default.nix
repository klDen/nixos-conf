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
      foot # terminal
      wofi # Dmenu is the default in the config but i recommend wofi since its wayland native
      xwayland # for legacy apps
      waybar libappindicator # status bar
      kanshi # autorandr
      gammastep # redshift for wayland
      swappy grim slurp # screenshot
      flashfocus
      firefox-wayland
      polkit_gnome
    ];
    extraSessionCommands = ''
      export _JAVA_AWT_WM_NONREPARENTING=1
      export MOZ_ENABLE_WAYLAND=1
      export MOZ_USE_XINPUT2=1
      export QT_QPA_PLATFORM=wayland
      export SDL_VIDEODRIVER=wayland
      export XDG_CURRENT_DESKTOP=sway
      export XDG_SESSION_TYPE=wayland
    '';
  };

  environment = {
    etc = {
      # Put config files in /etc. Note that you also can put these in ~/.config, but then you can't manage them with NixOS anymore!
      "sway/config".source = ./config;
      "xdg/waybar/config".source = ./waybar/config;
      "xdg/waybar/style.css".source = ./waybar/style.css;
      "xdg/swappy/config".source = ./swappy/config;
      "xdg/mako/config".source = ./mako/config;
      "xdg/electron-flags.conf".source = ./electron/electron-flags.conf;
      "kanshi/config".source = ./kanshi/config;
    };
    # polkit https://nixos.wiki/wiki/Sway
    pathsToLink = [ "/libexec" ];
  };

  fonts.fonts = with pkgs; [
    font-awesome # for waybar 
  ];

  # install flatpak: signal and zoom are crashing with wayland
  services.flatpak.enable = true;

  # required for firefox on wayland
  services.pipewire.enable = true;
  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [ 
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
      ];
      gtkUsePortal = true;
    };
  };

  #services.udev = {
  #   # autoswitch to proper display profile
  #   extraRules = ''
  #     ACTION=="change", SUBSYSTEM=="drm", RUN+="${pkgs.stdenv.shell} -c 'swaymsg -s $SWAYSOCK output eDP-1 enable && pkill kanshi && ${pkgs.kanshi}/bin/kanshi --config /etc/kanshi/config'"
  #   '';
  #}; 
}

