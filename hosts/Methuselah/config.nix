{ inputs, self, ... }:

{
  imports = [
    self.nixosModules.default
    (inputs.nixpkgs
      + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
  ];
  Aster = {
    isIso = true;
    user = "nixos";

    apps = {
      analysis.enable = false;
      android-tools.enable = false;
      chrome.enable = false;
      davinci.enable = false;
      discord.enable = false;
      foot.enable = true;
      gaming.enable = false;
      git.enable = false;
      shell.enable = true;
      unity.enable = false;
      vicinae.enable = true;
      vmware.enable = false;
      vscode.enable = false;
      zen.enable = true;
    };

    desktop = {
      gdm.enable = false;
      gnome-utils.enable = true;
      hyprland.enable = true;
      sddm.enable = false;
      theme.enable = true;
      tuigreet.enable = false;
    };

    hardware = {
      asus.enable = false;
      bluetooth.enable = false;
      compatibility.enable = true;
      nvidia.enable = false;
    };

    system = {
      agenix.enable = false;
      audio.enable = true;
      boot.enable = false; # I know it look funny, but isIso takes care of this
      # locale is unguarded
      # network is unguarded
      # nix.nix is unguarded
      quietBoot.enable = false;
      secureBoot.enable = false;
      # user.nix is unguarded
    };
  };

  # Identity
  networking.hostName = "Methuselah";
  nixpkgs.hostPlatform = "x86_64-linux";
  system.stateVersion = "26.05";

  # Copy flake to ISO. Maybe avoids a git clone
  environment.etc."nixos/flake".source = self;
}
