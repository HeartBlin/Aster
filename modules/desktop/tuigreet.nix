{ config, lib, pkgs, ... }:

{
  options.Aster.desktop.tuigreet.enable = lib.mkEnableOption "Tuigreet";

  config = lib.mkIf config.Aster.desktop.tuigreet.enable {
    services.greetd = {
      enable = true;
      useTextGreeter = true;

      settings.default_session = {
        command =
          "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-session";
        user = "greeter";
      };
    };
  };
}
