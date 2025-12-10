{ config, lib, pkgs, ... }:

let
  inherit (config.aster) user;
  gtkSettings.Settings = {
    gtk-theme-name = "Adwaita-dark";
    gtk-icon-theme-name = "Adwaita";
    gtk-cursor-theme-name = "Bibata-Modern-Ice";
    gtk-cursor-theme-size = 24;
    gtk-font-name = "Cantarell 11";
    gtk-application-prefer-dark-theme = true;
  };

  iniContent = lib.generators.toINI { } gtkSettings;

  gtk2Content = ''
    gtk-theme-name="${gtkSettings.Settings.gtk-theme-name}"
    gtk-icon-theme-name="${gtkSettings.Settings.gtk-icon-theme-name}"
    gtk-cursor-theme-name="${gtkSettings.Settings.gtk-cursor-theme-name}"
    gtk-cursor-theme-size=${toString gtkSettings.Settings.gtk-cursor-theme-size}
    gtk-font-name="${gtkSettings.Settings.gtk-font-name}"
  '';
in {
  users.users.${user}.packages = with pkgs; [
    gnome-themes-extra
    adwaita-icon-theme
    bibata-cursors
  ];

  hjem.users.${user} = {
    files = {
      ".config/gtk-3.0/settings.ini".text = iniContent;
      ".config/gtk-4.0/settings.ini".text = iniContent;
      ".gtkrc-2.0".text = gtk2Content;

      ".config/gtk-3.0/bookmarks".text = ''
        file:///home/${user}/Documents Documents
        file:///home/${user}/Downloads Downloads
        file:///home/${user}/Pictures Pictures
      '';
    };
  };
}
