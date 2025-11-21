{ config, pkgs, ... }:

{
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "bisexual";
      mode = "rgb";
      color_align = {
      	mode= "custom";
        custom_colors = [
            0
            0
            1
            2
	    2
            1
        ];
      };
      backend = "fastfetch";
      distro = "nixos_colorful";
    };
  };
  
  home.packages = with pkgs; [
    fastfetch
  ];
}
