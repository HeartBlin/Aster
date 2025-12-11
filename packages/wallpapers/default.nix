{ pkgs, lib, ... }:

let
  images = {
    "winter.webp" = {
      url =
        "https://drive.google.com/uc?export=download&id=1ehYslIBLgEqpBFzW61DYdtdtFTH2GKhi";
      sha256 = "sha256-cJYJeTitmrK8rgM/6U2FeZ6oSWvUXCmvh/eqmjrkFsc=";
    };

    "spring.webp" = {
      url =
        "https://drive.google.com/uc?export=download&id=1av4FH18mF-l1yADCRymDu22D0IWTH7Id";
      sha256 = "sha256-1vXmeDogj9y8uWMQYC3oxfk6oEtz8AGXTPBaG80Gtb8=";
    };

    "summer.webp" = {
      url =
        "https://drive.google.com/uc?export=download&id=1ZLXyJ4K4ZzLrr9SASXpT7luFC772jyyz";
      sha256 = "sha256-lglFtsZNHpE6VSDKlT0ENwPA3M+w3EweuoDdXxUZf34=";
    };

    "autumn.webp" = {
      url =
        "https://drive.google.com/uc?export=download&id=1fX1NPSqGJfw7EmPKNvFP4MKnHdCh_j1x";
      sha256 = "sha256-qTAxfDUvPLL8pkaFNSA6IxTSLaQHKZphdvo1MF1e3a4=";
    };
  };

  fetchWallpaper = name: src:
    pkgs.fetchurl {
      inherit (src) url sha256;
      inherit name;
    };

  entryList = lib.mapAttrsToList (name: src: {
    inherit name;
    path = fetchWallpaper name src;
  }) images;
in pkgs.linkFarm "aster-wallpapers" entryList
