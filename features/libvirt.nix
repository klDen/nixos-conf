{ pkgs, ... }: {
  virtualisation.libvirtd.enable = true;
  users.extraGroups.libvirtd.members = [ "klden" ];
  users.extraGroups.qemu-libvirtd.members = [ "klden" ];
  environment.systemPackages = with pkgs; [ virt-manager ];
}
