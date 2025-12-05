{ config, lib, pkgs, ... }:

{
  services.librespeed = {
    enable = true;
    useACMEHost = "vaporwing.party";
  };
}