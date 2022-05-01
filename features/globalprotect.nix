{ pkgs, ... }:

{
  # https://github.com/yuezk/GlobalProtect-openconnect/issues/69#issuecomment-988957394
  environment = {
    systemPackages = (with pkgs; [
      globalprotect-openconnect
    ]);
  };

  services.globalprotect = {
    enable = true;
    # if you need a Host Integrity Protection report
    csdWrapper = "${pkgs.openconnect}/libexec/openconnect/hipreport.sh";
  };
}

