{ config, pkgs, ... }:
{
  
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  
  ############################################################
  # CPU / Power (Laptop)
  ############################################################
  services.power-profiles-daemon.enable = true;
  powerManagement.cpuFreqGovernor = "balanced";

  # GPU
  services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;

    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = true;

    # Enable the Nvidia settings menu,
	  # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = true;
  };

## overrided by nix-hardware
# hardware.nvidia.prime = {
#    amdgpuBusId = "PCI:54:0:0";
#    nvidiaBusId = "PCI:1:0:0";
#  };

  boot.kernelModules = [ "kvm-amd" ];

}