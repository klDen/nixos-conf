{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      jetbrains.pycharm-community
    ]);
  };
}
