{ config, pkgs, ... }:
{

  imports = [
    # Include the results of the hardware scan.
    ./nixOSModules/wallpaper-engine-kde-plugin.nix # Or another path to the file
  ];

  nixos.pkgs = {
    wallpaper-engine-kde-plugin.enable = false;
  };

  system.stateVersion = "25.11";
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  ## Boot
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    plymouth = {
      enable = true;
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
    # Hide the OS choice for bootloaders.
    # It's still possible to open the bootloader list by pressing any key
    # It will just not appear on screen unless a key is pressed
    loader.timeout = 0;

  };

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

  ## Add $HOME/.local/bin in PATH
  environment.localBinInPath = true;
  ############################################################
  # Desktop (Wayland + KDE)
  ############################################################
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  programs.kdeconnect.enable = true;

  ## Audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.zsh.enable = true;

  ## User
  users.users.gabuscuv = {
    isNormalUser = true;
    description = "Gaby Bustillo del Cuvillo";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "adbusers"
      "audio"
      "video"
      "input"
      # virtualisation
      "libvirtd"
      "kvm"
      # Rocksmith 2014 / WineASIO
      "rtkit"
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ## System Packages (minimal) || Avoid install
  environment.systemPackages = with pkgs; [
    alvr
    duperemove
    vulkan-tools
    steam-run
    git
    git-lfs
    wget
    curl
    rtaudio
  ];

  ## Gamemode
  programs.gamemode.enable = true;

  ## Steam / VR
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    rocksmithPatch.enable = true;
  };

  # Unreal Engine binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libuuid
  ];

  # AppImage support, Needed for FMOD Studio and other apps
  programs.appimage = {
    enable = true;
    binfmt = true;
    package = pkgs.appimage-run.override {
      extraPkgs =
        pkgs:
        (with pkgs; [
          libxau
        ])
        ++ (with pkgs.xorg; [
          libICE
          libSM
          libX11
          libxcb
          libXcomposite
          libXcursor
          libxkbfile
          libXdamage
          libXext
          libXfixes
          libXi
          libXrandr
          libXrender
          libXScrnSaver
          libxshmfence
          libXtst
        ]);
    };
  };

  ## Virtualisation
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };

  networking.firewall.trustedInterfaces = [ "virbr0" ];

  # Misc
  services.hardware.openrgb.enable = true;

  # Android // TODO! | FIXME!
  programs.adb.enable = true;
  #services.udev.packages = with pkgs; [
  #android-udev-rules
  #];
}
