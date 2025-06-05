{ config, pkgs, lib, ... }:

let
  name = "Henry Moore";
  user = "henrym";
  email = "henrydmoore23@gmail.com";
in
{


  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        update = "sudo nixos-rebuild switch --flake .#thinkpad";
      };

      oh-my-zsh.enable = true;
      oh-my-zsh.plugins = [
        "git"
	"sudo"
	"dirhistory"
	"history"
      ];

    };

    git = {
      enable = true;
      userName = user;
      userEmail = email;

    };

    home-manager.enable = true;
  };
  
}
