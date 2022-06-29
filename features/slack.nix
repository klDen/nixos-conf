{ lib, pkgs, ... }:
let
  #slack = pkgs.slack.overrideAttrs (old: {
  #  installPhase = old.installPhase + ''
  #    rm $out/bin/slack

  #    makeWrapper $out/lib/slack/slack $out/bin/slack \
  #      --prefix XDG_DATA_DIRS : $GSETTINGS_SCHEMAS_PATH \
  #      --prefix PATH : ${lib.makeBinPath [pkgs.xdg-utils]} \
  #      --add-flags "--ozone-platform=wayland --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer"
  #  '';
  #  # -u flag (tray) broken in wayland 
  #});
in
{
  environment = {
    systemPackages = (with pkgs; [
      slack
    ]);
  };

  xdg = {
    portal = {
      enable = true;
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];
    };
  };
}

