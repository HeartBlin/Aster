{ config, lib, pkgs, ... }:

let ctx = config.aster;
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

  environment.shellAliases = {
    makeNix = "nh os switch";
    makeNixBoot = "nh os boot";
    cleanNix = "nh clean all";
  };

  users.users = lib.genAttrs ctx.users (_: { shell = pkgs.fish; });
}
