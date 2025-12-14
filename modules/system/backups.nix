# RECOVERY
#
# sudo RCLONE_CONFIG=/run/agenix/rclone restic -r rclone:gdrive:/<NAME> \
#   --password-file /run/agenix/restic mount /mnt/restore

{ config, lib, ... }:

let inherit (config.Aster) user;
in {
  options.Aster.system.backups.enable = lib.mkEnableOption "Restic Backups";

  config = lib.mkIf config.Aster.system.backups.enable {
    services.restic.backups.gdrive = {
      repository = "rclone:gdrive:/Aster";
      passwordFile = config.age.secrets.restic.path;
      rcloneConfigFile = config.age.secrets.rclone.path;
      initialize = true;

      paths = [
        "/home/${user}/Documents"
        "/home/${user}/Music"
        "/home/${user}/Pictures"
        "/home/${user}/Videos"
      ];

      pruneOpts = [ "--keep-daily 7" "--keep-weekly 4" "--keep-monthly 6" ];
      timerConfig = {
        OnCalendar = "14:00";
        Persistent = true;
        RandomizedDelaySec = "5m";
      };

      exclude = [
        "*.iso"
        "node_modules"
        ".venv"
        "target"
        ".git"
        "*.tmp"
        "*.log"
        ".cache"
        "Trash"
      ];
    };

    systemd.services."restic-backup-gdrive" = {
      after = [ "network-online.target" ];
      requires = [ "network-online.target" ];
      unitConfig.ConditionACPower = true;
    };
  };
}
