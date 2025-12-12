{ config, lib, pkgs, ... }:

{
  options.Aster.system.boot.enable = lib.mkEnableOption "Standard boot config";

  config = lib.mkIf config.Aster.system.boot.enable {
    boot = {
      kernelPackages = pkgs.linuxPackages;
      tmp.useTmpfs = true;
      initrd.systemd.enable = true;
      loader = {
        timeout = lib.mkDefault 0;
        efi.canTouchEfiVariables = true;
        systemd-boot = {
          enable = true;
          editor = false;
        };
      };
    };
  };
}
