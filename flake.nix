{
  description = "My Home Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      # use the follows attribute to use the same dependencies as nixpkgs
      # this way there wont be unnecessary duplications and inconsistensies
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs: {

    # laptop
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/laptop/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.sakuk = import ./home.nix;
        }
      ];
    };

    # virtual machines
    nixosConfigurations.vm-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./machines/vm/configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.sakuk = import ./home.nix;
        }

        disko.nixosModules.disko
      ];
    };
  };
}
