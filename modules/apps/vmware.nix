_: {
  virtualisation.vmware.host = {
    enable = true;
    extraConfig = ''
      mks.gl.allowUnsupportedDrivers = "TRUE"
      mks.vk.allowUnsupportedDrivers = "TRUE"
    '';
  };
}
