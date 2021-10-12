{ pkgs, ... }:

{
  # https://github.com/NixOS/nixpkgs/issues/107233#issuecomment-901051124
  nixpkgs.overlays = [
    (self: super:
    {
   zoomUsFixed = pkgs.zoom-us.overrideAttrs (old: {
      postFixup = old.postFixup + ''
        wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE
      '';});
   zoom = pkgs.zoom-us.overrideAttrs (old: {
      postFixup = old.postFixup + ''
        wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE
      '';});
      }
      )
  ];
  environment = {
    systemPackages = (with pkgs; [
      zoom
    ]);
  };
}
