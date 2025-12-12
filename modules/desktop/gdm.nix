{ config, lib, ... }:

{
  options.Aster.desktop.gdm.enable = lib.mkEnableOption "GDM Display Manager";

  config = lib.mkIf config.Aster.desktop.gdm.enable {
    services.displayManager.gdm = {
      enable = true;
      wayland = true;
    };
  };
}
