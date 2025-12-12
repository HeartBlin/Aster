{ config, inputs, lib, pkgs, ... }:

{
  options.Aster.system.secureBoot.enable =
    lib.mkEnableOption "Secure Boot (Lanzaboote)";

  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];
  config = lib.mkIf config.Aster.system.secureBoot.enable {
    environment.systemPackages = [ pkgs.sbctl ];

    boot = {
      bootspec.enable = true;
      loader.systemd-boot.enable = lib.mkForce false;
      lanzaboote = {
        enable = true;
        pkiBundle = "/var/lib/sbctl";
      };
    };
  };
}
