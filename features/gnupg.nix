{ pkgs, ... }: 
{
  programs.gnupg = {
    # Enabling the agent requires a system restart.
    agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryFlavor = "gtk2";
    };
  };
}

