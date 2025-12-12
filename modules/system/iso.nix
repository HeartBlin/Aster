{ config, lib, pkgs, ... }:

let inherit (lib) mkForce;
in {
  options.Aster.isIso =
    lib.mkEnableOption "ISO Configuration (Kernels, Compression, No-Password)";

  config = lib.mkIf config.Aster.isIso {
    security.sudo.wheelNeedsPassword = false;
    services.xserver.displayManager.lightdm.enable = mkForce false;
    boot.loader.timeout = mkForce 10;

    # MacGyver'ed kernel selector
    # Just gets the latest non-broken ZFS compatible kernel
    boot.kernelPackages = let
      latest = lib.last
        (lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version))
          (builtins.attrValues (lib.filterAttrs (name: kernelPackages:
            (builtins.match "linux_[0-9]+_[0-9]+" name) != null
            && (builtins.tryEval kernelPackages).success
            && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken))
            pkgs.linuxKernel.packages)));
    in mkForce latest;
  };
}
