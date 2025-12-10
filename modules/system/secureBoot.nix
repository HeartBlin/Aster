{ lib, pkgs, ... }:

let inherit (lib) mkForce;
in {
  environment.systemPackages = [ pkgs.sbctl ];

  boot = {
    bootspec.enable = true;
    loader.systemd-boot.enable = mkForce false;
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
  };
}
