{ config, inputs, lib, pkgs, ... }:

let inherit (config.Aster) user;
in {
  options.Aster = {
    user = lib.mkOption {
      description = "Primary user to create";
      type = lib.types.str;
      default = "";
    };

    wallpaper = lib.mkOption {
      description = "What wallpaper to use";
      type = lib.types.str;
      default = "";
    };
  };

  imports = [ inputs.hjem.nixosModules.default ];
  config = {
    users.users.${user} = {
      isNormalUser = true;
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
