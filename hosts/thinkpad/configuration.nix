{ config, lib, pkgs, ... }:
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  time.timeZone = "America/Los_Angeles";

  programs.git.enable = true;
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  powerManagement.enable = true;
  services.thermald.enable = true;  
  services.tlp.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.henrym = {
    isNormalUser = true;
    home = "/home/henrym";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  environment.systemPackages = with pkgs; [
  ];

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "24.11";

}

