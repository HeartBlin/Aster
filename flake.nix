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
    lanzaboote.inputs = {
      nixpkgs.follows = "nixpkgs";
      pre-commit.follows = "";
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
      inherit (nixpkgs.lib) filesystem genAttrs hasSuffix nixosSystem;
      inherit (builtins) attrNames filter pathExists readDir;

      # The package I expose could work on aarch.
      # They're wallpapers after all. If aarch doesn't support webp, it's BAD bad
      systems = [ "x86_64-linux" "aarch64-linux" ];

      # Auto-discover modules
      moduleList = filter (name: hasSuffix ".nix" name)
        (filesystem.listFilesRecursive ./modules);

      # Auto-discover hosts
      hostList = filter (name: pathExists ./hosts/${name}/config.nix)
        (attrNames (readDir ./hosts));

      # Auto-discover packages
      packageList = filter (name: pathExists ./packages/${name}/default.nix)
        (attrNames (readDir ./packages));
    in {
      nixosModules.default.imports = moduleList;
      nixosConfigurations = genAttrs hostList (hostName:
        nixosSystem {
          specialArgs = { inherit inputs self; };
          modules = [
            ./hosts/${hostName}/config.nix
            ./hosts/${hostName}/disko.nix # The jank, as ISO doesn't need this
          ];
        });

      formatter = genAttrs systems
        (system: nixpkgs.legacyPackages.${system}.nixfmt-classic);

      packages = genAttrs systems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in genAttrs packageList
        (name: pkgs.callPackage ./packages/${name} { }));
    };
}
