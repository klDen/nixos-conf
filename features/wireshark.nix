{ pkgs, ... }: {
  users.users.klden = {
    extraGroups = [ "wireshark" ];
  };

  programs.wireshark.enable = true;

  environment = {
    systemPackages = (with pkgs; [
      wireshark
    ]);
  };
}
