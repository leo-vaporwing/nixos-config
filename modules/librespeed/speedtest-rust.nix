{ config, lib, pkgs, ... }:

{
  services.librespeed = {
    enable = true;
    useACMEHost = "vaporwing.party";
    domain = "speedtest2.vaporwing.party";
    frontend = {
      enable = true;
      contactEmail = "example@example.com";
      servers = [
        {
          name = "vaporwing.party";
          server = "//speedtest2.vaporwing.party:8989";
        }
      ];
      useNginx = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 8989 ];
  networking.firewall.allowedUDPPorts = [ 8989 ];
}
