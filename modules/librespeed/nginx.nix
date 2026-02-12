{
  imports = [
    ../nginx
  ];
  services.nginx.virtualHosts."speedtest.vaporwing.party" = {
    forceSSL = true;
    useACMEHost = "vaporwing.party";
    locations."/" = {
      proxyPass = "http://127.0.0.1:8081";
      proxyWebsockets = false;
      extraConfig =
        "proxy_ssl_server_name on;" +
        "proxy_pass_header Authorization;" +
        "client_max_body_size 50M;";
    };
  };
}
