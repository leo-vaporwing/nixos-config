{
  description = "Leo's NixOS Systems Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-secrets = {
      url = "github:leo-vaporwing/nixos-secrets";
      flake = false;
    };
    quadlet-nix.url = "github:SEIAROTg/quadlet-nix";
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, sops-nix, nixos-secrets, quadlet-nix, ... }@inputs: {
    nixosConfigurations = {
      laptop-wsl = let
        username = "leov";
        specialArgs = {inherit username; inherit nixos-secrets; };
      in 
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          system = "x86_64-linux";
          modules = [
            ./hosts/laptop-wsl
            ./users/${username}/nixos.nix
	  
	    nixos-wsl.nixosModules.default {
              wsl.enable = true;
	      wsl.defaultUser = username;
	    }
            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.extraSpecialArgs = inputs // specialArgs;
	      home-manager.users.${username} = import ./users/${username}/home.nix;
	    }
            sops-nix.nixosModules.sops
            quadlet-nix.nixosModules.quadlet
          ];
        };
      rpi-400 = let
        username = "leov";
        specialArgs = { inherit username; inherit nixos-secrets; };
      in
        nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          modules = [
            ./hosts/rpi-400
            sops-nix.nixosModules.sops
            quadlet-nix.nixosModules.quadlet
          ];
        };
    };
  };
}
