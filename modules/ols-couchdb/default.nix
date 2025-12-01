{ config, lib, pkgs, ... }:

{
  imports = [
    ./container.nix
    ./nginx.nix
  ];
}