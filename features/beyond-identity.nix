{ pkgs, ... }:
{
  services.gnome.gnome-keyring.enable = true;
  # todo create Beyond Identity package for nix
  # //packages.beyondidentity.com/public/linux-authenticator/deb/ubuntu/pool/focal/main/b/be/beyond-identity_2.44.0-0/beyond-identity_2.44.0-0_amd64.deb
}

