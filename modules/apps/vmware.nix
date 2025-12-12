{ config, lib, ... }:

{
  options.Aster.apps.vmware.enable = lib.mkEnableOption "VMware Workstation";

  config = lib.mkIf config.Aster.apps.vmware.enable {
    virtualisation.vmware.host = {
      enable = true;
      extraConfig = ''
        mks.gl.allowUnsupportedDrivers = "TRUE"
        mks.vk.allowUnsupportedDrivers = "TRUE"
      '';
    };
  };
}
