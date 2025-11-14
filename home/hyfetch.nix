{ config, pkgs, ... }:

{
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "bisexual";
      mode = "rgb";
      color_align = {
      	mode = "horizontal";
      };
    };
  };
}
