{ config, lib, ... }:

{
  options.Aster.apps.git.enable = lib.mkEnableOption "Git /w sign";

  config = lib.mkIf config.Aster.apps.git.enable {
    programs.git.enable = true;

    hjem.users.${config.Aster.user}.files = {
      ".config/git/config".text = ''
        [commit]
          gpgsign = true

        [gpg]
          format = "ssh"

        [gpg "ssh"]
          allowedSignersFile = ${config.age.secrets.allowedSigner.path}

        [include]
          path = /run/agenix/gitPersona
      '';

      ".ssh/config".text = ''
        Host github.com
          User git
          HostName github.com
          PreferredAuthentications publickey
          IdentityFile ~/.ssh/githubAuth
      '';
    };
  };
}
