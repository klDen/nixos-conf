{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" "wl" ];
  boot.kernelModules = [ "kvm-amd" "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
  boot.initrd.luks.devices.root = { 
    device = "/dev/nvme0n1p2";
    preLVM = true;
  };

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/a417e131-afad-404f-a5fb-2eb14777bfa5";
      fsType = "xfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/B2D9-2C26";
      fsType = "vfat";
    };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  swapDevices =
    [ { device = "/dev/disk/by-uuid/99562496-cdc0-49fe-815f-0bd057449b11"; }
    ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "klden" ];
  };

  networking.hostName = "desktop";
 
  services.xserver.videoDrivers = [ "nouveau" ];
}

