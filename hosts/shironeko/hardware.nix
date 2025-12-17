{ config, pkgs, ... }:
{
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  boot.kernelModules = [ "kvm-amd" ];
}