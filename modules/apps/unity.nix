{ config, lib, pkgs, ... }:

{
  options.Aster.apps.unity.enable = lib.mkEnableOption "Unity environment";

  config = lib.mkIf config.Aster.apps.unity.enable {
    environment.systemPackages = with pkgs; [ unityhub jetbrains.rider ];
  };
}
