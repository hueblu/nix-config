{ config, pkgs, ... }:

let
  user = "henrym";
  home_dir = "/home/${user}";
  xdg_configHome = "${home_dir}/.config";
in
{
  imports = [
    ../shared/home.nix
  ];

  home = {
    enableNixpkgsReleaseCheck = false;
    username = "${user}";
    homeDirectory = "${home_dir}";
    packages = pkgs.callPackage ./packages.nix {};
    file = import ./files.nix { inherit user config pkgs; };
    stateVersion = "24.11";
  };

  programs = {
    kitty = {
      enable = true;
      themeFile = "Catppuccin-Macchiato";
      shellIntegration.enableZshIntegration = true;
      enableGitIntegration = true;
      font = {
        name = "FiraCode Nerd Font";
	size = 11;
      };
      settings = {
        background_opacity = 1.0;
	bold_font = "auto";
	italic_font = "auto";
	bold_italic_font = "auto";
      };
    };
  };
