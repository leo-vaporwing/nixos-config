{ pkgs, lib, config, nixos-secrets, ... }:

let
  secretsPath = builtins.toString nixos-secrets;
in
{
  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 80 443 ];
  
  sops.secrets.cloudflare_dns_token = {
    sopsFile = "${secretsPath}/cloudflare.yaml";
  };
  
  security.acme = {
    acceptTerms = true;
    defaults.email = "leo.vaporwing+acme@gmail.com";
    certs."vaporwing.party" = {
      dnsProvider = "cloudflare";
      dnsResolver = "1.1.1.1:53";
      credentialsFile = config.sops.secrets.cloudflare_dns_token.path;
      domain = "vaporwing.party";
      extraDomainNames = [ "*.vaporwing.party" ];
      reloadServices = [ "nginx" ];
    };
  };
  
  users.users."nginx".extraGroups = [ "acme" ];
}
