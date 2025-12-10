{ config, pkgs, ... }:

let inherit (config.aster) user;
in {
  users.users.${user}.packages = [ pkgs.google-chrome ];
  environment.etc."opt/chrome/policies/managed/extensions.json".text =
    builtins.toJSON {
      ExtensionInstallForcelist = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh;https://clients2.google.com/service/update2/crx"
        "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx"
        "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx"
      ];
    };
}
