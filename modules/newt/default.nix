{ config, lib, pkgs, nixos-secrets, ... }:
let
  secretsPath = builtins.toString nixos-secrets;
in
{
  sops.secrets = {
    "rpi-400-newt-env" = {
      sopsFile = "${secretsPath}/newt.yaml";
    };
  };

  services.newt = {
    enable = true;
    environmentFile = "${config.sops.secrets."rpi-400-newt-env".path}";
    settings = {
      endpoint = "pangolin.vaporwing.party";
    };
  };
}
