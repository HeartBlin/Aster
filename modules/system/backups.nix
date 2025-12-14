{ config, lib, pkgs, ... }:

let inherit (config.Aster) user;
in {
  options.Aster.system.backups.enable = lib.mkEnableOption "Restic Backups";

  config = lib.mkIf config.Aster.system.backups.enable {
    services.restic.backups.gdrive = {
      repository = "rclone:gdrive:/Aster";
      passwordFile = config.age.secrets.restic.path;
      rcloneConfigFile = config.age.secrets.rclone.path;
      initialize = true;
      runCheck = true;
      checkOpts = [ "--read-data-subset=10%" ];

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
      serviceConfig = {
        CPUSchedulingPolicy = "batch";
        Nice = 19;
        IOSchedulingClass = "best-effort";
        IOSchedulingPriority = 7;
      };
    };

    environment.systemPackages = [
      pkgs.restic
      pkgs.rclone
      (pkgs.writeShellScriptBin "restic-gdrive" ''
        export RCLONE_CONFIG=${config.age.secrets.rclone.path}
        export RESTIC_PASSWORD_FILE=${config.age.secrets.restic.path}
        exec ${pkgs.restic}/bin/restic -r rclone:gdrive:/Aster "$@"
      '')
    ];
  };
}
