{ pkgs, ... }: {
  networking = {
    wireless.enable = false;
    wireless.iwd.enable = true;
  };

  services = {
    connman.enable = true;
    connman.wifi.backend = "iwd";
  };
}

