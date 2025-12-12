{ config, inputs, lib, pkgs, ... }:

{
  options.Aster.apps.shell.enable =
    lib.mkEnableOption "Shell environment (Fish, Starship, Zoxide, Nix-Index)";

  imports = [ inputs.nix-index-database.nixosModules.nix-index ];
  config = lib.mkIf config.Aster.apps.shell.enable {
    users.users.${config.Aster.user}.shell = pkgs.fish;
    programs = {
      command-not-found.enable = false;

      fish = {
        enable = true;
        interactiveShellInit = "set fish_greeting";
        shellAliases = {
          ls = "${pkgs.eza}/bin/eza -l";
          cat = "${pkgs.bat}/bin/bat";
        };
      };

      starship = {
        enable = true;
        settings = {
          format = "$directory$git_branch$git_status$character";
          add_newline = false;
          directory.disabled = false;
          character = {
            disabled = false;
            success_symbol = "[λ](bold purple)";
            error_symbol = "[λ](bold red)";
          };
        };
      };

      nix-index-database.comma.enable = true;
      nix-index = {
        enable = true;
        enableFishIntegration = true;
      };

      zoxide = {
        enable = true;
        enableFishIntegration = true;
        flags = [ "--cmd cd" ];
      };
    };
  };
}
