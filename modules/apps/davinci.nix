{ config, lib, pkgs, ... }:

{
  options.Aster.apps.davinci.enable = lib.mkEnableOption "DaVinci Resolve";

  config = lib.mkIf config.Aster.apps.davinci.enable {
    users.users.${config.Aster.user}.packages = [ pkgs.davinci-resolve ];
  };
}
