{ pkgs, ... }:

{
  environment = {
    etc.jdk = with pkgs; {
        source = jdk;
    };
  };
}
