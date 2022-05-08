{ pkgs, ... }:

{
  environment = {
    etc.go = with pkgs; {
        source = go;
    };
  };
}
