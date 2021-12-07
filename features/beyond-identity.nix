{ pkgs, ... }: {
  services.gnome.gnome-keyring.enable = true;

  environment = {
    systemPackages = (with pkgs; [
      beyond-identity
      #(callPackage ./beyond-identity {})
    ]);
  };
}
