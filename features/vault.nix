{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      vault
    ]);
  };
}
