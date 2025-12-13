{ config, lib, pkgs, ... }:

{
  options.Aster.apps.gaming.enable =
    lib.mkEnableOption "Gaming programs & tools";

  config = lib.mkIf config.Aster.apps.gaming.enable {
    programs = {
      gamemode = {
        enable = true;
        enableRenice = true;
        settings.general = {
          softrealtime = "auto";
          renice = 15;
        };
      };

      steam = {
        enable = true;
        extraCompatPackages = [ pkgs.proton-ge-bin ];
      };

      gamescope = {
        enable = true;
        capSysNice = true;
      };
    };

    environment = {
      sessionVariables."PROTON_NO_WM_DECORATION" = "1";
      systemPackages = with pkgs; [
        prismlauncher
        protontricks
        (pkgs.writeShellScriptBin "nvidia-gamescope" ''
          export __NV_PRIME_RENDER_OFFLOAD=1
          export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
          export __GLX_VENDOR_LIBRARY_NAME=nvidia
          export __VK_LAYER_NV_optimus=NVIDIA_only
          exec gamescope "$@"
        '')
      ];
    };

    # SteamOS kernel tweaks
    boot.kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
      "kernel.split_lock_mitigate" = 0;
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
    };

    # SCX
    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
    };

    # NTSync
    boot.kernelModules = [ "ntsync" ];
    services.udev.extraRules = ''KERNEL=="ntsync", MODE="0666"'';
  };
}
