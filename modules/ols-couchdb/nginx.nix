{
  imports = [
    ../nginx
  ];
  services.nginx.virtualHosts."ols.vaporwing.party" = {
    useACMEHost = "vaporwing.party";
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5984";
      proxyWebsockets = true;
      extraConfig =
        "# Set proxy headers" +
        "proxy_set_header Host $host;" +
        "proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;" +
        "proxy_set_header X-Forwarded-Proto $scheme;";
    };
  };
}
