{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      pipenv
    ]);
  };
}
