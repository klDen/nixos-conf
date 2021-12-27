{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      linuxPackages.broadcom_sta
    ]);
  };
}
