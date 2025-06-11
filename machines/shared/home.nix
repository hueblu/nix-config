{ machine, ... }:
{
  programs = {
    git = {
      enable = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        update = "sudo nixos-rebuild switch --flake .#${machine.hostname}";
      };

      oh-my-zsh = {
        enable = true;
	plugins = [
	  "git"
	  "sudo"
	  "dirhistory"
	  "history"
	];
      };
    };

    home-manager.enable = true;
  };
}
