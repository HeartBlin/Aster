{ config, pkgs, ... }:

let inherit (config.aster) user;
in {
  users.users.${user}.extraGroups = [ "adbusers" ];
  programs.adb.enable = true;
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
}
