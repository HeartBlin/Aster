{ config, lib, ... }:

{
  options.Aster.system.audio.enable = lib.mkEnableOption "PipeWire";

  config = lib.mkIf config.Aster.system.audio.enable {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
}
