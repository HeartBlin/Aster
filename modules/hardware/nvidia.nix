{ config, lib, pkgs, ... }:

let
  cfg = config.Aster.hardware.nvidia;
  nvPkgs = config.boot.kernelPackages.nvidiaPackages;

  customDriver = nvPkgs.mkDriver {
    version = "590.44.01";
    sha256_64bit = "sha256-VbkVaKwElaazojfxkHnz/nN/5olk13ezkw/EQjhKPms=";
    openSha256 = "sha256-ft8FEnBotC9Bl+o4vQA1rWFuRe7gviD/j1B8t0MRL/o=";
    persistencedSha256 = "sha256-nHzD32EN77PG75hH9W8ArjKNY/7KY6kPKSAhxAWcuS4=";
    settingsSha256 = lib.fakeSha256; # Not used, but required lmao
  };

  # Pick the latest and greatest driver, packaged or not
  latestDriver = lib.last
    (lib.sort (a: b: lib.versionOlder a.version b.version) [
      nvPkgs.stable
      nvPkgs.beta
      customDriver
    ]);

in {
  options.Aster.hardware.nvidia.enable =
    lib.mkEnableOption "NVIDIA (Hybrid Graphics)";

  config = lib.mkIf cfg.enable {
    nixpkgs.config = {
      nvidia.acceptLicense = true;
      cudaSupport = true;
    };

    services.xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    };

    hardware.nvidia = {
      package = latestDriver;
      modesetting.enable = true;
      open = true;
      nvidiaSettings = false;
      nvidiaPersistenced = true;
      powerManagement.enable = true;
      dynamicBoost.enable = true;

      # NOTE: mkForce if a host needs other ids
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

    environment.systemPackages = with pkgs; [
      btop
      vulkan-tools
      vulkan-loader
      vulkan-extension-layer
      libva
      libva-utils
    ];
  };
}
