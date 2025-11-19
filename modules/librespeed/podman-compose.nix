{ pkgs, lib, config, ... }:

{
  # Runtime
  virtualisation.podman = {
    enable = true;
    autoPrune.enable = true;
    dockerCompat = true;
  };

  virtualisation.oci-containers.backend = "podman";

  # Containers
  virtualisation.oci-containers.containers."speedtest" = {
    image = "ghcr.io/librespeed/speedtest:latest";
    environment = {
      "MODE" = "standalone";
    };
    ports = [
      "8081:8080/tcp"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=speedtest"
    ];
  };
}
