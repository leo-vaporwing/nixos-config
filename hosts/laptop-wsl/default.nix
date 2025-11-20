# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, username, nixos-secrets, ... }:

{
  imports = [
    # NixOS-WSL modules handled by flake

    ../../modules/librespeed
    ../../modules/foundryvtt
    ../../modules/ssh_agent
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  environment.systemPackages= with pkgs; [
    git
    vim
    wget
  ];
  environment.variables.EDITOR = "vim";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      firefox
      neovim
    ];
  };
  # sops-nix stuff
  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";
  sops.defaultSopsFile = "${builtins.toString nixos-secrets}/default.yaml";

  networking.hostName = "laptop-wsl";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
