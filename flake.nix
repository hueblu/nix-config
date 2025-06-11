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
  };

  outputs = { home-manager, self, nixpkgs, ... }@inputs:
  let
    inherit (nixpkgs) lib;

    machines =
      lib.mapAttrs
        (name: value: import ./machines/${name})
        (lib.filterAttrs 
          (file: type: (file != "shared") && (type == "directory")) 
          (builtins.readDir ./machines)
        );

    linuxMachines = 
      builtins.filter 
        (machine: 
	  (machine.systemArch == "x86_64-linux") 
	  || (machine.system == "aarch64-linux")
	) 
	machines;

    darwinMachines = 
      builtins.filter 
        (machine: 
	  (machine.system == "x86_64-darwin") 
	  || (machine.system == "aarch64-darwin")
	) 
        machines;
  in 
  {
    nixosConfigurations = 
      lib.mapAttrs
	(n: machine:
          nixpkgs.lib.nixosSystem rec {
	    inherit (machine) system;
	    specialArgs = { inherit inputs machine; };
	      modules = machine.modules
	        ++ [
		  home-manager.nixosModules.home-manager 
	          { home-manager = {
		    useGlobalPkgs = true;
	            useUserPackages = true;
		    extraSpecialArgs = specialArgs;
		  }; }
		] 
		++ builtins.map
	          (user: {
		    home-manager.users.${user.user} = {
		      home = {
		        enableNixpkgsReleaseCheck = false;
			username = user.user;
			homeDirectory = "/home/${user.user}";
			stateVersion = "24.11";
		      };
		      imports = user.homeModules;
		    };
		  })
		  machine.users;
            } 
          ) 
          linuxMachines;
  };
}
