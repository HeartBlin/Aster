# TODO: This module is WIP
# It now assumes only Vega uses it
# When I get my server on this flake, I'll generalize it
# Maybe by doing more options?

{ config, inputs, lib, pkgs, self, ... }:

{
  options.Aster.system.agenix.enable = lib.mkEnableOption "Agenix Secrets";

  imports = [ inputs.agenix.nixosModules.default ];
  config = lib.mkIf config.Aster.system.agenix.enable {
    age.identityPaths = [ "/etc/ssh/LOVE" ];
    age.secrets = {
      heart.file = "${self}/secrets/heart.age";
      allowedSigner = {
        file = "${self}/secrets/allowedSigner.age";
        owner = config.Aster.user;
        mode = "600";
      };
      gitPersona = {
        file = "${self}/secrets/gitPersona.age";
        owner = config.Aster.user;
        mode = "600";
      };
    };

    users.users.${config.Aster.user}.hashedPasswordFile =
      config.age.secrets.heart.path;

    environment.systemPackages =
      [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };
}
