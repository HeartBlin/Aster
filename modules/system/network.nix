_: {
  networking = {
    nftables.enable = true;
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = true;
    };
  };

  services.resolved.enable = true;

  # Some boot speed improvements
  systemd.network.wait-online.enable = false;
  systemd.services = {
    NetworkManager-wait-online.enable = false;
    systemd-networkd.stopIfChanged = false;
    systemd-resolved.stopIfChanged = false;
  };
}
