{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      poetry
    ]);
  };
}
