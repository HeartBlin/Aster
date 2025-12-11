{
  description = "Aster - NixOS configuration flake";
  inputs = {
    # Core
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # System management
    agenix.url = "github:ryantm/agenix";
    hjem.url = "github:feel-co/hjem";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Extras
    awww.url = "git+https://codeberg.org/LGFae/awww";
    hyprland.url = "github:hyprwm/Hyprland";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit.follows = "";
    };

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "";
    };
  };

  outputs = { nixpkgs, self, ... }@inputs:
    let
      inherit (nixpkgs.lib) genAttrs nixosSystem;
      inherit (builtins) readDir pathExists attrNames filter;
      systems = [ "x86_64-linux" ];
      hosts = filter (name: pathExists ./hosts/${name}/config.nix)
        (attrNames (readDir ./hosts));
    in {
      nixosConfigurations = genAttrs hosts (hostName:
        nixosSystem {
          specialArgs = { inherit inputs self; };
          modules =
            [ ./hosts/${hostName}/config.nix ./hosts/${hostName}/disko.nix ];
        });

      formatter = genAttrs systems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in pkgs.nixfmt-classic);

      packages = genAttrs systems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./packages/default.nix { inherit pkgs; });
    };
}
