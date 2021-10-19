{ pkgs, ... }: {
  virtualisation.docker.enable = true;

  users.users.klden = {
    extraGroups = [ "lxd" "docker" ];
  };

  environment = {
    systemPackages = (with pkgs; [
      docker-compose
    ]);
  };
}
