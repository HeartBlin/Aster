_: {
  boot = {
    consoleLogLevel = 3;
    initrd.verbose = false;
    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "loglevel=3"
      "rd.systemd.show_status=auto"
    ];
  };
}
