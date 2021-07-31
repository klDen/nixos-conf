{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
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

  swapDevices =
    [ { device = "/dev/disk/by-uuid/99562496-cdc0-49fe-815f-0bd057449b11"; }
    ];

  nix.maxJobs = lib.mkDefault 16;

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    trustedUsers = [ "root" "klden" ];
  };

  networking.hostName = "desktop";
 
  # Use the systemd-boot EFI boot loader.
  boot = {
    loader = {
      timeout = 10;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        version = 2;
        devices = [ "nodev" ];
        efiSupport = true;
        useOSProber = true;
      };
    };
    
    cleanTmpDir = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users = {
    extraUsers.klden = {
      extraGroups = [ "wheel" "video" "audio" "disk" ];
      group = "users";
      isNormalUser = true;
      uid = 1000;
      shell = pkgs.zsh;
    };

    users.klden.subUidRanges = [{ startUid = 10000; count = 65536; }];
    users.klden.subGidRanges = [{ startGid = 10000; count = 65536; }];
    users.root.initialHashedPassword = "";
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };
  
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  services.xserver.videoDrivers = [ "nvidia" ];
}
