{ config, lib, pkgs, ... }:

let
  cfg = config.Aster.desktop.theme;
  gtkSettings = {
    Settings = {
      gtk-theme-name = "Adwaita-dark";
      gtk-icon-theme-name = "Adwaita";
      gtk-cursor-theme-name = "Bibata-Modern-Ice";
      gtk-cursor-theme-size = 24;
      gtk-font-name = "Cantarell 11";
      gtk-application-prefer-dark-theme = true;
    };
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
  options.Aster.desktop.theme.enable =
    lib.mkEnableOption "System-wide GTK Theme (Adwaita Dark / Bibata)";

  config = lib.mkIf cfg.enable {
    users.users.${config.Aster.user}.packages = with pkgs; [
      gnome-themes-extra
      adwaita-icon-theme
      bibata-cursors
    ];

    hjem.users.${config.Aster.user}.files = {
      ".config/gtk-3.0/settings.ini".text = iniContent;
      ".config/gtk-4.0/settings.ini".text = iniContent;
      ".gtkrc-2.0".text = gtk2Content;

      # /mods and /mod_overrides are cause I mod PayDay 2
      ".config/gtk-3.0/bookmarks".text = ''
        file:///home/${config.Aster.user}/Documents Documents
        file:///home/${config.Aster.user}/Downloads Downloads
        file:///home/${config.Aster.user}/Pictures Pictures
        file:///home/${config.Aster.user}/Music Music
        file:///home/${config.Aster.user}/Videos Videos

        file:///home/${config.Aster.user}/.steam/steam/steamapps/common/PayDay%202/mods /mods
        file:///home/${config.Aster.user}/.steam/steam/steamapps/common/PayDay%202/assets/mod_overrides /mod_overrides
      '';
    };
  };
}
