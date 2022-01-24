{ pkgs, ... }:

{
  environment = {
    systemPackages = (with pkgs; [
      #terraform_0_12
      terraform_0_13
      #terraform
    ]);
  };
}
