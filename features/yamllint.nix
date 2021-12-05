{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      yamllint
    ]);
  };
}
