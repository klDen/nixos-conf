{ pkgs, ... }:

{
  environment = {
    etc.jdk17 =  with pkgs; {
        source = jdk17_headless;
    };
    etc.jdk11 =  with pkgs; {
        source = jdk11;
    };
  };
}
