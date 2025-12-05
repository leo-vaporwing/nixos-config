{ config, lib, pkgs, ... }:

{
  imports = [
    ./container.nix
    ./speedtest-rust.nix
    ./nginx.nix
  ];
}
