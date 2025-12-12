{ config, lib, pkgs, ... }:

{
  options.Aster.desktop.gnome-utils.enable =
    lib.mkEnableOption "GNOME programs";

  config = lib.mkIf config.Aster.desktop.gnome-utils.enable {
    services = {
      gnome.gnome-keyring.enable = true;
      gvfs.enable = true;
    };

    security.pam.services.login.enableGnomeKeyring = true;
    programs.dconf.enable = true;

    systemd.user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };

    users.users.${config.Aster.user}.packages = with pkgs; [
      nautilus
      loupe
      file-roller
      seahorse
      gnome-disk-utility
    ];
  };
}
