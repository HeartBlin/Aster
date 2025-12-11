{ config, pkgs, ... }:

let inherit (config.aster) user;
in {
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

  users.users.${user}.shell = pkgs.fish;
}
