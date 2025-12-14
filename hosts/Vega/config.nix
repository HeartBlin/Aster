{ lib, pkgs, self, ... }:

{
  imports = [ self.nixosModules.default ];
  Aster = {
    isIso = false;
    user = "heartblin";
    apps = {
      analysis.enable = true;
      android-tools.enable = false;
      chrome.enable = false;
      davinci.enable = true;
      discord.enable = false;
      foot.enable = true;
      gaming.enable = true;
      git.enable = true;
      shell.enable = true;
      unity.enable = true;
      vicinae.enable = true;
      vmware.enable = true;
      vscode.enable = true;
      zen.enable = true;
    };

    desktop = {
      gdm.enable = true;
      gnome-utils.enable = true;
      hyprland.enable = true;
      sddm.enable = false;
      theme.enable = true;
      tuigreet.enable = false;
    };

    hardware = {
      asus.enable = true;
      bluetooth.enable = true;
      compatibility.enable = true;
      nvidia.enable = true;
    };

    system = {
      agenix.enable = true;
      audio.enable = true;
      backups.enable = true;
      boot.enable = true;
      # locale is unguarded
      # network is unguarded
      # nix.nix is unguarded
      quietBoot.enable = true;
      secureBoot.enable = true;
      # user.nix is unguarded
    };
  };

  # Module overrides
  boot = {
    kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod_latest;
    kernelParams = [ "amd_pstate=active" ]; # The funny
  };

  # Identity
  networking.hostName = "Vega";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";
}
