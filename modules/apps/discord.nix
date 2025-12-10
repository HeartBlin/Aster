{ config, lib, pkgs, ... }:

let ctx = config.aster;
in {
  users.users = lib.genAttrs ctx.users (_: {
    packages = [
      (pkgs.discord.override {
        withOpenASAR = true;
        withVencord = true;
        withTTS = true;
      })
    ];
  });
}
