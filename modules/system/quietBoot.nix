{ config, lib, ... }:

{
  options.Aster.system.quietBoot.enable = lib.mkEnableOption "Quiet Booting";

  config = lib.mkIf config.Aster.system.quietBoot.enable {
    boot = {
      consoleLogLevel = 3;
      initrd.verbose = false;

      plymouth = {
        enable = true;
        theme =
          "bgrt"; # I actually don't know what "bgrt" means, it's the OEM logo
      };

      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "loglevel=3"
        "rd.systemd.show_status=auto"
      ];
    };
  };
}
