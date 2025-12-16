{ config, pkgs, ... }:

{
  hardware.graphics = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}