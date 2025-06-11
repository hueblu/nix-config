{ config, lib, pkgs, ... }: 
let
  inherit (lib) mkIf mkOption types;
  cfg = config.local.hyprland;
  defaultBool = mkOption { type = types.bool; default = true; };
in
{
  options = {
    local.hyprland = {
      enable = defaultBool;
      withRofi = defaultBool;
      withWaybar = defaultBool;
      withKitty = defaultBool;
    };
  };

  config = {
  home.packages = with pkgs; [
    hyprlock
  ];
  
  programs = {
    rofi = mkIf cfg.withRofi {
      enable = true;
      modes = [
        "drun"
	"filebrowser"
	"window"
	"ssh"
      ];
      font = "FiraCode Nerd Font";
    };

    waybar = mkIf cfg.withWaybar {
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

    kitty = mkIf cfg.withKitty {
      enable = true;
      themeFile = "Catppuccin-Macchiato";
      shellIntegration.enableZshIntegration = true;
      enableGitIntegration = true;
      font = {
        name = "FiraCode Nerd Font";
	size = 11.0;
      };
      settings = {
        background_opacity = 1.0;
	bold_font = "auto";
	italic_font = "auto";
	bold_italic_font = "auto";
      };
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;

    settings = {
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
  };
  };
}
