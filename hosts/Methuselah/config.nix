{ config, inputs, lib, pkgs, self, ... }:

let inherit (lib) mkForce;
in {
  imports = [
    # From flake inputs (req)
    # inputs.agenix.nixosModules.default
    # inputs.disko.nixosModules.default
    inputs.hjem.nixosModules.default

    # From flake inputs (opt)
    inputs.hyprland.nixosModules.default
    # inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nix-index-database.nixosModules.nix-index

    # ISO
    (inputs.nixpkgs
      + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")

    # From 'system'
    "${self}/modules/system/audio.nix"
    "${self}/modules/system/boot.nix"
    "${self}/modules/system/locale.nix"
    "${self}/modules/system/network.nix"
    "${self}/modules/system/nix.nix"
    # "${self}/modules/system/quietBoot.nix"
    # "${self}/modules/system/secureBoot.nix"
    "${self}/modules/system/users.nix"

    # From 'apps'
    # "${self}/modules/apps/analysis.nix"
    # "${self}/modules/apps/android.nix"
    # "${self}/modules/apps/chrome.nix"
    # "${self}/modules/apps/git.nix"
    # "${self}/modules/apps/davinci.nix"
    # "${self}/modules/apps/discord.nix"
    "${self}/modules/apps/foot.nix"
    # "${self}/modules/apps/gaming.nix"
    "${self}/modules/apps/shell.nix"
    "${self}/modules/apps/vicinae.nix"
    # "${self}/modules/apps/vmware.nix"
    # "${self}/modules/apps/vscode.nix"
    "${self}/modules/apps/zen.nix"

    # From 'desktop'
    # "${self}/modules/desktop/gdm.nix"
    "${self}/modules/desktop/gnome-utils.nix"
    "${self}/modules/desktop/hyprland.nix"
    # "${self}/modules/desktop/ly.nix"
    # "${self}/modules/desktop/sddm.nix"
    "${self}/modules/desktop/theme.nix"
    # "${self}/modules/desktop/tuigreet.nix"

    # From 'hardware'
    # "${self}/modules/hardware/asus.nix"
    # "${self}/modules/hardware/bluetooth.nix"
    # "${self}/modules/hardware/nvidia.nix"
  ];

  # Users
  aster.users = [ "nixos" ];
  users.users."nixos".initialHashedPassword = lib.mkForce null;

  # Me, myself and I
  environment.etc."nixos/flake".source = self;

  # It's an ISO c'mon
  security.sudo.wheelNeedsPassword = false;

  # ISO settings
  image.fileName = "methuselah.iso";
  isoImage = {
    volumeID = "Aster_NixOS";
    squashfsCompression = "zstd -Xcompression-level 19";
  };

  # Module overrides
  services.xserver.displayManager.lightdm.enable = mkForce false;
  boot = {
    loader.timeout = lib.mkForce 10;
    kernelPackages = let
      latest = lib.last
        (lib.sort (a: b: (lib.versionOlder a.kernel.version b.kernel.version))
          (builtins.attrValues (lib.filterAttrs (name: kernelPackages:
            (builtins.match "linux_[0-9]+_[0-9]+" name) != null
            && (builtins.tryEval kernelPackages).success
            && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken))
            pkgs.linuxKernel.packages)));
    in lib.mkForce latest;
  };

  # Identity
  networking.hostName = "Methuselah";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
