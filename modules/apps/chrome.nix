{ config, lib, pkgs, ... }:

let ctx = config.aster;
in {
  environment.etc."opt/chrome/policies/managed/extensions.json".text =
    builtins.toJSON {
      ExtensionInstallForcelist = [
        "ddkjiahejlhfcafbddmgiahcphecmpfh;https://clients2.google.com/service/update2/crx"
        "nngceckbapebfimnlniiiahkandclblb;https://clients2.google.com/service/update2/crx"
        "eimadpbcbfnmbkopoojfekhnkhdbieeh;https://clients2.google.com/service/update2/crx"
      ];
    };

  users.users =
    lib.genAttrs ctx.users (_: { packages = [ pkgs.google-chrome ]; });
}
