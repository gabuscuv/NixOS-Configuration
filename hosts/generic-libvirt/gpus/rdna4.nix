{ config, pkgs, ... }:
{
    hardware.firmware = [ pkgs.linux-firmware ];
    hardware.amdgpu.opencl.enable = true;

    services.lact.enable = true;
}