{ config, ... }:

let
  inherit (config.aster) user;
  gitConfig = ''
    [commit]
      gpgsign = true

    [gpg]
      format = "ssh"

    [gpg "ssh"]
      allowedSignersFile = ${config.age.secrets.allowedSigner.path}

    [include]
      path = /run/agenix/gitPersona
  '';

  sshConfig = ''
    Host github.com
      User git
      HostName github.com
      PreferredAuthentications publickey
      IdentityFile ~/.ssh/githubAuth
  '';
in {
  programs.git.enable = true;
  hjem.users.${user}.files = {
    ".config/git/config".text = gitConfig;
    ".ssh/config".text = sshConfig;
  };
}
