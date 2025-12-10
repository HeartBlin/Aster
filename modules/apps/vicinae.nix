{ config, lib, pkgs, ... }:

let
  ctx = config.aster;
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
  users.users = lib.genAttrs ctx.users (_: { packages = [ pkgs.vicinae ]; });

  hjem.users = lib.genAttrs ctx.users
    (_: { files."~/.config/vicinae/vicinae.json".text = vicinaeConfig; });
}
