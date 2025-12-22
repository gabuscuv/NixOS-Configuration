{
  imports = [
    ./hardware.nix
    ##./gpus/rdna4.nix
    ## Virtualized eGPU
    #./gpus/turing.nix
    #./gpus/maxwell.nix
  ];

  networking.hostName = "generic-libvirt";
}