{ pkgs, lib, config, nixos-secrets, ... }:
let
  foundryUid = 3000;
  foundryGid = 3000;
  volumeMountRoot = "/var/lib/foundryvtt";
  secretsPath = builtins.toString nixos-secrets;
in
{
  users.users.foundry = {
    isSystemUser = true;
    linger = true;
    group = "foundry";
    uid = foundryUid;
    autoSubUidGidRange = true;
  };
  users.groups.foundry = {
    gid = foundryGid;
  };
  
  systemd.tmpfiles.rules = [ 
    "d ${volumeMountRoot}/data  0770 ${toString foundryUid} ${toString foundryGid} -"
    "d ${volumeMountRoot}/cache 0750 ${toString foundryUid} ${toString foundryGid} -"
  ];

  sops.secrets = {
    "foundryvtt.env" = {
      sopsFile = "${secretsPath}/foundryvtt.yaml";
    };
    "foundryvtt.r2.json" = {
      sopsFile = "${secretsPath}/foundryvtt.yaml";
      owner = config.users.users.foundry.name;
    };
  };

  virtualisation.quadlet.enable = true;

  virtualisation.quadlet.containers.foundryvtt = {
    autoStart = true;
    serviceConfig = {
      RestartSec = "10";
      Restart = "always";
    };
    containerConfig = {
      hostname = "foundryvtt";
      image = "felddy/foundryvtt:13";
      environments = {
        "CONTAINER_CACHE" = "/cache";
        "FOUNDRY_MINIFY_STATIC_FILES" = "true";
        "FOUNDRY_TELEMETRY" = "true";
        "FOUNDRY_AWS_CONFIG" = "/secrets/r2.json";
        "FOUNDRY_COMPRESS_WEBSOCKET" = "true";
        "FOUNDRY_HOSTNAME" = "foundry.vaporwing.party";
        "FOUNDRY_WORLD" = "rivers-of-blood-thoughts-seize";
      };
      environmentFiles = [
        config.sops.secrets."foundryvtt.env".path
      ];
      volumes = [
        "${volumeMountRoot}/cache:/cache:rw"
        "${volumeMountRoot}/data:/data:rw"
        "${toString config.sops.secrets."foundryvtt.r2.json".path}:/secrets/r2.json:ro"
      ];
      publishPorts = [ "30000:30000" ];
      user = "${toString foundryUid}:${toString foundryGid}";
    };
  };
}
