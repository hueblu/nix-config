{
  description = "henry's super awesome nixos config";

  nixConfig = {
    extra-trusted-public-keys = "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=";
    extra-substituters = "https://devenv.cachix.org";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = { nixvim, home-manager, self, nixpkgs, ... }@inputs:
  let
    user = "henrym";
    machines = [
      { name = "thinkpad"; system = "x86_64-linux"; }
    ];

    linuxMachines = (builtins.filter (machine: (machine.system == "x86_64-linux") || (machine.system == "aarch64-linux")) machines);
    darwinMachines = (builtins.filter (machine: (machine.system == "x86_64-darwin") || (machine.system == "aarch64-darwin")) machines);

    devShell = machine: let pkgs = nixpkgs.legacyPackages.${machine.system}; in {
      default = with pkgs; mkShell {
        nativeBuildInputs = with pkgs; [ bashInteractive git ];
	shellHook = with pkgs; ''
	  export EDITOR=nvim
	'';
      };
    };
  in 
  {
    devShells = builtins.map devShell machines;
    nixosConfigurations = builtins.listToAttrs (builtins.map (machine: with machine; rec {
      inherit name;
      value = nixpkgs.lib.nixosSystem {
	inherit system;
	specialArgs = { inherit inputs user; };
	modules = [
	  ./hosts/${name}
	  home-manager.nixosModules.home-manager
	  {
	    home-manager.useGlobalPkgs = true;
	    home-manager.useUserPackages = true;
	    home-manager.users.${user} = { imports = [
	      ./modules/${name}/home.nix
	      nixvim.homeModules.nixvim
	    ]; };
	    home-manager.extraSpecialArgs = { inherit inputs user; };
	  }
	];
      }; 
      }
    ) linuxMachines);
  };
}
