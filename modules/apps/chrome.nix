{ config, lib, pkgs, ... }:

{
  options.Aster.apps.chrome.enable =
    lib.mkEnableOption "Google Chrome with managed extensions";

  config = lib.mkIf config.Aster.apps.chrome.enable {
    users.users.${config.Aster.user}.packages = [ pkgs.google-chrome ];
    environment.etc."opt/chrome/policies/managed/extensions.json".text =
      builtins.toJSON {
        ExtensionInstallForcelist = [
          # uBlock Origin Lite
          "ddkjiahejlhfcafbddmgiahcphecmpfh;https://clients2.google.com/service/update2/crx"
          # Bitwarden
          "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx"
          # Dark Reader
          "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx"
        ];
      };
  };
}
