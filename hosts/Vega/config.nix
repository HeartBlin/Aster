{ config, inputs, modulesPath, lib, pkgs, self, ... }:

let inherit (lib) mkForce;
in {
  imports = [
    # From flake inputs (req)
    inputs.agenix.nixosModules.default
    inputs.disko.nixosModules.default
    inputs.hjem.nixosModules.default

    # From flake inputs (opt)
    inputs.hyprland.nixosModules.default
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.nix-index-database.nixosModules.nix-index

    # Unknown hardware
    (modulesPath + "/installer/scan/not-detected.nix")

    # From 'system'
    "${self}/modules/system/audio.nix"
    "${self}/modules/system/boot.nix"
    "${self}/modules/system/locale.nix"
    "${self}/modules/system/network.nix"
    "${self}/modules/system/nix.nix"
    "${self}/modules/system/quietBoot.nix"
    "${self}/modules/system/secureBoot.nix"
    "${self}/modules/system/users.nix"

    # From 'apps'
    "${self}/modules/apps/analysis.nix"
    # "${self}/modules/apps/android.nix"
    # "${self}/modules/apps/chrome.nix"
    "${self}/modules/apps/davinci.nix"
    "${self}/modules/apps/discord.nix"
    "${self}/modules/apps/foot.nix"
    "${self}/modules/apps/gaming.nix"
    "${self}/modules/apps/git.nix"
    "${self}/modules/apps/shell.nix"
    "${self}/modules/apps/vicinae.nix"
    "${self}/modules/apps/vmware.nix"
    "${self}/modules/apps/vscode.nix"
    "${self}/modules/apps/zen.nix"

    # From 'desktop'
    # "${self}/modules/desktop/gdm.nix"
    "${self}/modules/desktop/gnome-utils.nix"
    "${self}/modules/desktop/hyprland.nix"
    # "${self}/modules/desktop/ly.nix"
    # "${self}/modules/desktop/sddm.nix"
    "${self}/modules/desktop/theme.nix"
    "${self}/modules/desktop/tuigreet.nix"

    # From 'hardware'
    "${self}/modules/hardware/asus.nix"
    "${self}/modules/hardware/bluetooth.nix"
    "${self}/modules/hardware/nvidia.nix"
  ];

  # Global Aster config
  aster.users = [ "heartblin" ]; # List of users to create

  # Module overrides
  boot = {
    plymouth.enable = mkForce false;
    kernelPackages = mkForce pkgs.linuxPackages_zen;
    kernelParams = [ "amd_pstate=active" ];
  };

  # Specifics
  hardware.cpu.amd.updateMicrocode = true;
  services.fstrim.enable = true;

  # Secrets
  age = {
    identityPaths = [ "/etc/ssh/LOVE" ]; # Without LOVE it cannot be seen
    secrets = {
      heart.file = "${self}/secrets/heart.age";
      allowedSigner = {
        file = "${self}/secrets/allowedSigner.age";
        owner = "heartblin";
        mode = "600";
      };

      gitPersona = {
        file = "${self}/secrets/gitPersona.age";
        owner = "heartblin";
        mode = "600";
      };
    };
  };

  # Feed secrets
  users.users.heartblin = {
    initialPassword = mkForce null;
    hashedPasswordFile = config.age.secrets.heart.path;
  };

  # Identity
  environment.systemPackages =
    [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  networking.hostName = "Vega";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
