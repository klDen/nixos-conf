{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      python37Full
    ]);
  };
}
