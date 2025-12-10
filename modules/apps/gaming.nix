{ pkgs, ... }:

{
  programs = {
    gamemode = {
      enable = true;
      enableRenice = true;
    };

    steam = {
      enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };

  environment.systemPackages = [ pkgs.prismlauncher pkgs.protontricks ];
}
