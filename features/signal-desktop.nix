{ lib, pkgs, ... }:
let
  signal-desktop = pkgs.signal-desktop.overrideAttrs (old: {
    installPhase = old.installPhase + ''
      rm $out/bin/signal-desktop

      makeWrapper $out/lib/Signal/signal-desktop $out/bin/signal-desktop \
        --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
        --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
        --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform"
    '';
    # broken in wayland: --start-in-tray --enable-features=WebRTCPipeWireCapturer
    # https://github.com/signalapp/Signal-Desktop/issues/5350
  });
in
{
  environment = {
    systemPackages = (with pkgs; [
      signal-desktop
    ]);
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
      gtkUsePortal = true;
    };
  };
}

