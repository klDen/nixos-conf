{ pkgs, ... }:

{
  environment = {
    etc.scala = with pkgs; {
        source = scala;
    };
  };
}
