{ config, pkgs, ... }:

let
  inherit (config.aster) user;
  vicinaeConfig = builtins.toJSON {
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
in {
  users.users.${user}.packages = [ pkgs.vicinae ];
  hjem.users.${user}.files.".config/vicinae/vicinae.json".text = vicinaeConfig;
}
