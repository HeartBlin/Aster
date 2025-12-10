{ config, pkgs, ... }:

let inherit (config.aster) user;
in {
  users.users.${user} = {
    packages = with pkgs; [ nmap tcpdump wireshark ];
    extraGroups = [ "wireshark" ];
  };

  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    usbmon.enable = true;
  };
}
