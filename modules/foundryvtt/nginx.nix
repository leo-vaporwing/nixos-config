{

services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."foundry.vaporwing.party" = {
        enableACME = false;
        forceSSL = false;
        locations."/" = {
            proxyPass = "http://127.0.0.1:30000";
            proxyWebsockets = false;
            extraConfig =
                "proxy_ssl_server_name on;" +
                "proxy_pass_header Authorization;";
        };
    };
};

networking.firewall.allowedTCPPorts = [ 80 443 ];
networking.firewall.allowedUDPPorts = [ 80 443 ];
}
