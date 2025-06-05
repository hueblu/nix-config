{ pkgs, ... }:
{
  imports = [
    ./hardware.nix
  ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.WLR_NO_HARDWARE_CURSORS = "1";

  nixpkgs.config.allowUnfree = true;

  fonts.enableDefaultPackages = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  programs = {
    hyprland.enable = true;
    zsh.enable = true;
    mtr.enable = true;
    git.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  services = {
    mullvad-vpn = {
      enable = true;
      package = pkgs.mullvad-vpn;
    };

    greetd = {
      enable = true;
      settings = {
        default_session.command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --cmd Hyprland";
	default_session.user = "henrym";
      };
    };

    resolved.enable = true;
    thermald.enable = true;
    tlp.enable = true;
    openssh.enable = true;

    pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "thinkpad";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  powerManagement.enable = true;

  users.users.henrym = {
    isNormalUser = true;
    home = "/home/henrym";
    shell = pkgs.zsh;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
  };

  system.stateVersion = "24.11";
}

