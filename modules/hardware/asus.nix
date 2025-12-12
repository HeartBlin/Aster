{ config, lib, ... }:

{
  options.Aster.hardware.asus.enable = lib.mkEnableOption "ASUS laptop support";

  config = lib.mkIf config.Aster.hardware.asus.enable {
    services = {
      supergfxd.enable = true;
      asusd = {
        enable = true;
        enableUserService = true;
      };
    };
  };
}
