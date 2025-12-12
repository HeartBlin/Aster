{ config, lib, ... }:

{
  options.Aster.desktop.sddm.enable = lib.mkEnableOption "SDDM Display Manager";

  config = lib.mkIf config.Aster.desktop.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
}
