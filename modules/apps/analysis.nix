{ config, lib, pkgs, ... }:

{
  options.Aster.apps.analysis.enable =
    lib.mkEnableOption "Network analysis tools";

  config = lib.mkIf config.Aster.apps.analysis.enable {
    users.users.${config.Aster.user} = {
      packages = with pkgs; [ nmap tcpdump wireshark ];
      extraGroups = [ "wireshark" ];
    };

    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };
}
