{ pkgs, ... }:

let
  fetchGoogleDrive = name: id: sha256: {
    inherit name;
    path = pkgs.fetchurl {
      inherit name sha256;
      url = "https://drive.google.com/uc?export=download&id=${id}";
    };
  };
in pkgs.linkFarm "aster-wallpapers" [
  (fetchGoogleDrive "winter.webp" "1ehYslIBLgEqpBFzW61DYdtdtFTH2GKhi"
    "sha256-cJYJeTitmrK8rgM/6U2FeZ6oSWvUXCmvh/eqmjrkFsc=")
  (fetchGoogleDrive "spring.webp" "1av4FH18mF-l1yADCRymDu22D0IWTH7Id"
    "sha256-1vXmeDogj9y8uWMQYC3oxfk6oEtz8AGXTPBaG80Gtb8=")
  (fetchGoogleDrive "summer.webp" "1ZLXyJ4K4ZzLrr9SASXpT7luFC772jyyz"
    "sha256-lglFtsZNHpE6VSDKlT0ENwPA3M+w3EweuoDdXxUZf34=")
  (fetchGoogleDrive "autumn.webp" "1fX1NPSqGJfw7EmPKNvFP4MKnHdCh_j1x"
    "sha256-qTAxfDUvPLL8pkaFNSA6IxTSLaQHKZphdvo1MF1e3a4=")
]
