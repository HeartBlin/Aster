{ config, lib, pkgs, ... }:

let ctx = config.aster;
in {
  users.users = lib.genAttrs ctx.users (_: { extraGroups = [ "adbusers" ]; });

  programs.adb.enable = true;
  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
}
