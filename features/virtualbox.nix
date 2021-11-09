{ pkgs, ... }: {
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true;
  };
  virtualisation.virtualbox.guest.enable = true;
  users.extraGroups.vboxusers.members = [ "klden" ];
}
