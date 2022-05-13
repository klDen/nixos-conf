{ pkgs, ... }: {

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

  i18n = {
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  services = {
    pcscd.enable = true;

    udev = {
      packages = with pkgs; [
        yubikey-personalization
        android-udev-rules
      ];
    };

    # Enable CUPS to print documents.
    #printing.enable = true;

    xserver = {
      layout = "us";
      xkbVariant = "altgr-intl";

      displayManager = {
        autoLogin = {
          enable = true;
          user = "klden";
        };
      };
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;

  time.timeZone = "America/Montreal";

  system.stateVersion = "22.05";
}
