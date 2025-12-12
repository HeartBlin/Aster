{ config, lib, pkgs, ... }:

{
  options.Aster.apps.gaming.enable =
    lib.mkEnableOption "Gaming programs & tools";

  config = lib.mkIf config.Aster.apps.gaming.enable {
    programs = {
      gamemode = {
        enable = true;
        enableRenice = true;
      };

      steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };
    };

    environment.systemPackages = with pkgs; [ prismlauncher protontricks ];
  };
}
