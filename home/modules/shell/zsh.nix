{ machine, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      update = "sudo nixos-rebuild switch --flake .#${machine.name}";
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
}
