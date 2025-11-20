{

services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    virtualHosts."speedtest.vaporwing.party" = {
        enableACME = false;
        forceSSL = false;
        locations."/" = {
            proxyPass = "http://127.0.0.1:8081";
            proxyWebsockets = false;
            extraConfig =
                "proxy_ssl_server_name on;" +
                "proxy_pass_header Authorization;";
        };
    };
};
}
