{ pkgs, user, system, ... }:
let
  home_dir = "/home/${user.userName}";
  packages = with pkgs; [
    firefox
    (prismlauncher.override {
      additionalLibs = [ xorg.libX11 xorg.libXcursor ];
    })
    (discord.override {
      withVencord = true;
    })
    gcc
    cargo
    rustc
    gh
  ];
in
{
  imports = [
    ./modules/gui/hyprlandCatppuccin.nix
    ./modules/shell/zsh.nix
  ];

  home = {
    inherit packages;
    enableNixpkgsReleaseCheck = false;
    username = "${user.userName}";
    homeDirectory = "${home_dir}";
    stateVersion = "24.11";
  };

  programs = {
    git = {
      enable = true;
      userName = "${user.name}";
      userEmail = "${user.email}";
    };
    home-manager.enable = true;
  };

  services = {
    dunst = {
      enable = true;
    };
  };

  systemd.user.startServices = "sd-switch";

