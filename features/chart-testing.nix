{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      chart-testing
    ]);
  };
}
