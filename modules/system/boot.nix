{ pkgs, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages;

    tmp.useTmpfs = true;
    initrd.systemd.enable = true;

    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
      };
    };
  };
}
