{ config, lib, pkgs, ... }:

{
  options.Aster.apps.android-tools.enable =
    lib.mkEnableOption "Android tools (ADB and Waydroid)";

  config = lib.mkIf config.Aster.apps.android-tools.enable {
    users.users.${config.Aster.user}.extraGroups = [ "adbusers" ];
    programs.adb.enable = true;
    virtualisation.waydroid = {
      enable = true;
      package = pkgs.waydroid-nftables;
    };
  };
}
