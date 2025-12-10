{ config, inputs, lib, pkgs, ... }:

let inherit (config.aster) user;
in {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.lix;
    channel.enable = false;

    registry = lib.mapAttrs (_: v: { flake = v; })
      (lib.filterAttrs (_: x: lib.isType "flake" x) inputs);

    nixPath = lib.mapAttrsToList (x: _: "${x}=flake:${x}") config.nix.registry;

    settings = {
      accept-flake-config = lib.mkForce false;
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
      keep-derivations = true;
      keep-outputs = true;
      trusted-users = [ "root" "@wheel" ];
      warn-dirty = false;

      substituters = [ "https://hyprland.cachix.org" ];
      trusted-substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  documentation = {
    nixos.enable = false;
    man.enable = false;
    info.enable = false;
  };

  programs.nh = {
    enable = true;
    flake = "/home/${user}/Documents/Aster";
  };

  environment.shellAliases = {
    makeNix = "nh os switch";
    makeNixBoot = "nh os boot";
    cleanNix = "nh clean all";
  };
}
