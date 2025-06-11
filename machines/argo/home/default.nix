{ config, machine, pkgs, ... }:
let
  user = config.home.username;
in
{
  imports = [
    ../../shared/home.nix
  ];

  home = {
    packages = pkgs.callPackage ./packages.nix {};
    file = import ./files.nix { inherit user config pkgs; };
  };

  programs = {
    rofi = {
      enable = true;
      modes = [
        "drun"
      ];
      font = "FiraCode Nerd Font";
    };

    waybar = {
      enable = true;
     
      settings = {
        mainBar = {
          layer = "top";
	  position = "top";
	  height = 30;
	  output = [
	    "eDP-1"
	  ];
	  modules-left = [
	    "hyprland/workspaces"
	    "hyprland/submap"
	    "wlr/taskbar"
	  ];
 	  modules-center = [
	    "hyprland/window"
	  ];
        };
      };
    };

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
        background-opacity = 1.0;
	bold_font = "auto";
	italic_font = "auto";
	bold_italic_font = "auto";
      };
    };
  };

  wayland.windowManager.hyprland = {
    "$mod" = "SUPER";

    bind = [
      "$mod, T, exec, kitty"
      "$mod, Space, exec, rofi -show drun"
      "$mod, Q, killactive"
      "$mod, F, togglefloating"
      "$mod_SHIFT, F, fullscreen"
    ];

    exec-once = "waybar";
  };

  services = {
    dunst = {
      enable = true;
    };
  };

  systemd.user.startServices = "sd-switch";
}
