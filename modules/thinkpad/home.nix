{ nixvim, config, pkgs, ... }:

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
    rofi = {
      enable = true;
      modes = [
        "drun"
        "filebrowser"
	"window"
	"ssh"
      ];
      font = "FiraCode Nerd Font";
    };

    nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      colorschemes.catppuccin.enable = true;

      plugins = {
        lualine.enable = true;
	lspconfig.enable = true;
	cmp = {
	  enable = true;
	  autoEnableSources = true;
	  settings.sources = [
	    { name = "nvim_lsp"; }
	    { name = "path"; }
	    { name = "buffer"; }
	  ];
	};
      };

      lsp.servers = {
	nil_ls.enable = true;
        rust_analyzer.enable = true;
      };
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

	  modules-left = [ "hyprland/workspaces" "hyprland/submap" "wlr/taskbar" ];
	  modules-center = [ "hyprland/window" ];
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

  systemd.user.startServices = "sd-switch";
}
