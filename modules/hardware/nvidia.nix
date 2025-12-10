{ config, pkgs, lib, ... }:

let
  inherit (config.boot.kernelPackages.nvidiaPackages) stable beta;
  custom = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "590.44.01";
    sha256_64bit = "sha256-VbkVaKwElaazojfxkHnz/nN/5olk13ezkw/EQjhKPms=";
    openSha256 = "sha256-ft8FEnBotC9Bl+o4vQA1rWFuRe7gviD/j1B8t0MRL/o=";
    persistencedSha256 = "sha256-nHzD32EN77PG75hH9W8ArjKNY/7KY6kPKSAhxAWcuS4=";
    settingsSha256 = lib.fakeSha256; # Not used, but required lmao
  };

  allDrivers = [ stable beta custom ];
  sortDrivers =
    lib.sort (a: b: lib.versionOlder a.version b.version) allDrivers;
  latest = lib.last sortDrivers;
in {
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  nixpkgs.config = {
    nvidia.acceptLicense = true;
    cudaSupport = true;
  };

  environment.systemPackages = with pkgs; [
    btop
    vulkan-tools
    vulkan-loader
    vulkan-extension-layer
    libva
    libva-utils
  ];

  hardware.nvidia = {
    package = latest;
    dynamicBoost.enable = true;
    modesetting.enable = true;
    nvidiaSettings = false;
    open = true;
    nvidiaPersistenced = true;
    powerManagement.enable = true;
    prime = {
      amdgpuBusId = "PCI:6:0:0";
      nvidiaBusId = "PCI:1:0:0";
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
    extraPackages32 = with pkgs.pkgsi686Linux; [ nvidia-vaapi-driver ];
  };
}
