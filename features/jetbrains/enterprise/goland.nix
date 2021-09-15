{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      jetbrains.goland
    ]);
  };
}
