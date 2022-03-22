{ pkgs, ... }:
{
  environment = {
    systemPackages = (with pkgs; [
      retext
    ]);
  };
}

