{ config, pkgs, ... }:

let inherit (config.aster) user;
in {
  users.users.${user}.packages = [
    (pkgs.discord.override {
      withOpenASAR = true;
      withVencord = true;
      withTTS = true;
    })
  ];
}
