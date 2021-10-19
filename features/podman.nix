{ pkgs, ... }:
{
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = false;
    };
  };
  environment = {
    systemPackages = (with pkgs; [
      podman-compose
    ]);
  };
}

