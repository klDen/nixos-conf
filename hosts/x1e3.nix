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
  # required to detect udev hotplug events
  boot.extraModprobeConfig = ''
    options nvidia-drm modeset=1
  '';

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/fcf811f8-ba4b-449c-a669-b310c2fc1c62";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/E106-9125";
      fsType = "vfat";
    };

  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

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

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [ "root" "klden" ];
    };
  };

  networking.hostName = "x1e3";
 
  services = {
    xserver = {
      libinput.enable = true;
      videoDrivers = [ "nouveau" ];
      #videoDrivers = [ "nvidia" ];
      #screenSection = ''
      #  Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      #  Option         "AllowIndirectGLXProtocol" "off"
      #  Option         "TripleBuffer" "on"
      #'';
    };
  };

  hardware = {
    nvidia.prime = {
      sync.enable = false;

      # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
      nvidiaBusId = "PCI:1:0:0";

      # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
      intelBusId = "PCI:0:2:0";
    };

    # x1e3 has a different output name for some reasons 
    pulseaudio.extraConfig = "set-default-sink alsa_output.pci-0000_01_00.1.hdmi-stereo";
  };

  system.activationScripts.ldso = lib.stringAfter [ "usrbinenv" ] ''
    mkdir -m 0755 -p /lib64
    ln -sfn ${pkgs.glibc.out}/lib64/ld-linux-x86-64.so.2 /lib64/ld-linux-x86-64.so.2.tmp
    mv -f /lib64/ld-linux-x86-64.so.2.tmp /lib64/ld-linux-x86-64.so.2 # atomically replace
  '';


