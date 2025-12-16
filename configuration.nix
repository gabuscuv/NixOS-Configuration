{ config, pkgs, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  system.stateVersion = "25.11";

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  ## Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ## Networking  
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  ## Networking
  networking.networkmanager.enable = true;

  ## Locale
  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "extd";
  };

  # Configure console keymap
  console.keyMap = "uk";

  ############################################################
  # Desktop (Wayland + KDE)
  ############################################################
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;

  ## Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  ## User
  users.users.gabuscuv = {
    isNormalUser = true;
    description = "Gaby Bustillo del Cuvillo";
    shell = pkgs.zsh;
    extraGroups = [ "networkmanager" "wheel" "adbusers" "audio" "video" "input" ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  
  ## System Packages (minimal) || Avoid install
  environment.systemPackages = with pkgs; [
    alvr
    vulkan-tools
    steam-run
    git
    git-lfs
    wget
    curl
  ];
  
  ## Gamemode
  programs.gamemode.enable = true;

  ## Android Devices
  services.udev.packages = with pkgs; [
    android-udev-rules
  ];
    
  ## Steam / VR
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  # Unreal Engine binaries
  programs.nix-ld.enable = true;
  
  # Android
  services.udev.packages = with pkgs; [
  android-udev-rules
];
}

  
