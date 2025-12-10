{ config, inputs, lib, pkgs, ... }:

let inherit (config.aster) user;
in {
  options.aster = {
    user = lib.mkOption {
      description = "Primary user to create";
      type = lib.types.str;
      default = "";
    };

    wallpaper = lib.mkOption {
      description = "What wallpaper to use for Hyprland";
      type = lib.types.str;
      default = "";
    };
  };

  config = {
    users.users.${user} = {
      isNormalUser = true;
      initialPassword = "password"; # Change this after nixos-install
      home = "/home/${user}";
      extraGroups = [ "wheel" "networkmanager" ];
    };

    hjem = {
      clobberByDefault = true;
      linker = inputs.hjem.packages.${pkgs.stdenv.hostPlatform.system}.smfh;
      users.${user} = {
        inherit user;
        enable = true;
        directory = "/home/${user}";
      };
    };
  };
}
