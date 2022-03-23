{ pkgs, ... }: {
  environment = {
    systemPackages = (with pkgs; [
      networkmanagerapplet
      networkmanager-openvpn
    ]);
  };
  networking = {
    wireless.enable = false; # disable wpa_sup
    wireless.iwd.enable = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
  };
}

