{ config, lib, pkgs, ... }:

{
  options.Aster.apps.discord.enable =
    lib.mkEnableOption "Discord (Vencord really)";

  config = lib.mkIf config.Aster.apps.discord.enable {
    users.users.${config.Aster.user}.packages = [
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
        withTTS = true;
      })
    ];
  };
}
