{ config, lib, pkgs, ... }:

let ctx = config.aster;
in {
  users.users = lib.genAttrs ctx.users (_: {
    packages = with pkgs; [ nmap tcpdump wireshark ];
    extraGroups = [ "wireshark" ];
  });

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };
}
