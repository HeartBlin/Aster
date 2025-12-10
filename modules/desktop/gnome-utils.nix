{ config, pkgs, lib, ... }:

let ctx = config.aster;
in {
  services = {
    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };

  security.pam.services.login.enableGnomeKeyring = true;

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

  users.users = lib.genAttrs ctx.users (_: {
    packages = with pkgs; [
      nautilus
      loupe
      file-roller
      seahorse
      gnome-disk-utility
      adwaita-icon-theme
    ];
  });

  programs.dconf.enable = true;
}
