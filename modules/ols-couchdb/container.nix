{ pkgs, lib, config, nixos-secrets, ... }:
let
  volumeMountRoot = "/var/lib/docker-ols-couchdb";
  secretsPath = builtins.toString nixos-secrets;
in
{  
  systemd.tmpfiles.rules = [ 
    "d ${volumeMountRoot}/couchdb-data  0700 root root -"
    "d ${volumeMountRoot}/couchdb-etc 0700 root root -"
  ];

  sops.secrets = {
    "ols-couchdb.env" = {
      sopsFile = "${secretsPath}/ols-couchdb.yaml";
    };
  };

  virtualisation.quadlet.enable = true;

  virtualisation.quadlet.containers.ols-couchdb = {
    autoStart = true;
    serviceConfig = {
      RestartSec = "10";
      Restart = "always";
    };
    containerConfig = {
      hostname = "ols-couchdb";
      image = "couchdb";
      # environments = { };
      environmentFiles = [
        config.sops.secrets."ols-couchdb.env".path
      ];
      volumes = [
        "${volumeMountRoot}/couchdb-data:/opt/couchdb/data:rw"
        "${volumeMountRoot}/couchdb-etc:/opt/couchdb/etc/local.d:rw"
      ];
      publishPorts = [ "5984:5984" ];
    };
  };
}
