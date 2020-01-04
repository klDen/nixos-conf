{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ 
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/fcf811f8-ba4b-449c-a669-b310c2fc1c62";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E106-9125";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/f7ededc4-e61a-4cab-a92a-0788b9338b57"; }
    ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;

  boot.initrd.luks.devices.root = { 
    device = "/dev/nvme0n1p2";
    preLVM = true;
  };

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

  networking.hostName = "x1e3";
 
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

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment = {
    systemPackages = (with pkgs; [
      globalprotect-openconnect 
      vault terraform_0_13 
      poetry 
      google-cloud-sdk 
      zoom-us
      python3Full
      jetbrains.idea-ultimate
      jetbrains.datagrip
      jetbrains.goland
      jetbrains.pycharm-professional
      jetbrains.webstorm
    ]);
  };

  services.globalprotect = {
    enable = true;
    # if you need a Host Integrity Protection report
    csdWrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };
  services.xserver.libinput.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  hardware.nvidia.prime = {
    sync.enable = true;

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
  };

  # x1e3 has a different output name for some reasons 
  hardware.pulseaudio.extraConfig = "set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo";
}
