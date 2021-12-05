{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      yamale
    ]);
  };
}
