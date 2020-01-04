{ pkgs, ... }: {
  programs.adb = {
    enable = true;
  };
  users.extraUsers.klden.extraGroups = [ "adbusers" ];
}

