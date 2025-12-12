{ config, lib, pkgs, ... }:

{
  options.Aster.apps.vicinae.enable = lib.mkEnableOption "Vicinae launcher";

  config = lib.mkIf config.Aster.apps.vicinae.enable {
    users.users.${config.Aster.user}.packages = [ pkgs.vicinae ];

    hjem.users.${config.Aster.user}.files.".config/vicinae/vicinae.json".text =
      builtins.toJSON {
        closeOnFocusLoss = true;
        considerPreedit = false;
        faviconService = "google";
        font = {
          normal = "TeX Gyre Adventor";
          size = 11;
        };
        keybinding = "default";
        keybinds = { };
        popToRootOnClose = true;
        rootSearch.searchFiles = false;
        theme.name = "vicinae-dark";
        window = {
          csd = true;
          opacity = 0.75;
          rounding = 10;
        };
      };
  };
}
