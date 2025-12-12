# Welcome to the Jank™ drawer©

{ config, inputs, lib, ... }:

{
  options.Aster.hardware.compatibility.enable =
    lib.mkEnableOption "Hardware compatibility (firmware)";

  # Did I only throw this here cause I didn't know where else to put it?
  # Yes. I did!
  imports = [ inputs.disko.nixosModules.default ];

  config = lib.mkIf config.Aster.hardware.compatibility.enable {
    services.fstrim.enable = true; # TODO: Remove when I have a system with HDDs
    hardware = {
      enableRedistributableFirmware = lib.mkDefault true;
      cpu.amd.updateMicrocode = true; # No INTEL in this house boys
    };
  };
}
