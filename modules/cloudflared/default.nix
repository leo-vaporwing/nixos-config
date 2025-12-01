{ config, lib, pkgs, nixos-secrets, ... }:
let
  secretsPath = builtins.toString nixos-secrets;
in
{
  sops.secrets = {
    "rpi-400-tunnel-creds" = {
      sopsFile = "${secretsPath}/cloudflare.yaml";
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "4446e04e-4236-47fd-8cf6-d565ffa2edab" = {
        credentialsFile = "${config.sops.secrets."rpi-400-tunnel-creds".path}";
        default = "http_status:404";
      };
    };
  };
}
