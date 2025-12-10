{ config, pkgs, ... }:

let inherit (config.aster) user;
in { users.users.${user}.packages = [ pkgs.davinci-resolve ]; }
