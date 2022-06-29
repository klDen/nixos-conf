{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      #terraform_0_13
      terraform
    ]);
  };
}
