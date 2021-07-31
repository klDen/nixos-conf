{ pkgs, ... }: {

  i18n = {
    extraLocaleSettings = {
      LC_MESSAGES = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  environment = {
    systemPackages = (with pkgs; [
      vlc
      yubikey-personalization yubikey-manager-qt pinentry-gtk2
      volumeicon cmst pavucontrol
      libreoffice 
      pcmanfm xournalpp zathura
      chromium
      libsForQt5.ark
      docker-compose
      scrot
      slack
      #scrcpy
    ]);
  };

  services = {
    pcscd.enable = true;
    udev.packages = with pkgs; [
      yubikey-personalization
      android-udev-rules
    ];

    # Enable CUPS to print documents.
    #printing.enable = true;

    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      
      layout = "us";
      xkbVariant = "altgr-intl";

      displayManager = {
        autoLogin = {
          enable = true;
          user = "klden";
        };
        lightdm = {
          enable = true;
        };
      };
    };
  };

  hardware = {
    pulseaudio = {
      enable = true;
      extraConfig = "set-default-source alsa_input.usb-Blue_Microphones_Yeti_X_2052SG005LJ8_888-000313110306-00.analog-stereo\nset-default-sink alsa_output.pci-0000_0a_00.1.hdmi-stereo";
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
}
