{ config, lib, pkgs, ... }:

{
  options.Aster.hardware.bluetooth.enable =
    lib.mkEnableOption "Bluetooth support and Galaxy Buds client";

  config = lib.mkIf config.Aster.hardware.bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };

    environment.systemPackages = [ pkgs.galaxy-buds-client ];
    systemd.user.services.mpris-proxy = {
      description = "Mpris proxy";
      after = [ "network.target" "sound.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
    };
  };
}
