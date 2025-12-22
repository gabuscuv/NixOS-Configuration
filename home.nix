{ config, pkgs, ... }:
{
  home.username = "gabuscuv";
  home.homeDirectory = "/home/gabuscuv";
  home.stateVersion = "25.11";

  xdg.enable = true;

  ############################################################
  # Shell
  ############################################################
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = ["git"];
      theme = "agnoster";
    };
  };

  home.shellAliases = {
    virsh = "virsh -c qemu:///system";
    gitpro = "GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa_pro -F /dev/null' git";
    duperemove="duperemove --hashfile=$HOME/deduperhash.db";
    upgrade="nix flake update --flake /etc/nixos#$HOST";
    # Wine Stuff
    wine64 = "WINEPREFIX=\"$WINEPREFIX\" WINEARCH=win64 wine64";
    wine32 = "WINEPREFIX=\"$WINEPREFIX32\" WINEARCH=win32 wine";
    wine = "wine64";
    ## XDG
    wget = "wget --hsts-file=\ xdg.dataHome + "/wget-hsts\"";
  };

  home.sessionVariables = rec {
    # PATH=$PATH:$HOME/.local/bin:$HOME/.dotnet:$HOME/.npm-global/bin:/var/lib/flatpak/exports/bin:$GEM_HOME/ruby/2.7.0/bin:$HOME/.dotnet/tools:$GOPATH/bin;
    # WINE Stuff
    WINEPREFIX= xdg.dataHome + "/wine";
    WINEPREFIX32= xdg.dataHome + "/wine32";
    
    ## Gaming Stuff
    PROTON_HIDE_NVIDIA_GPU="0";
    PROTON_ENABLE_NVAPI="1";
    PROTON_ENABLE_NGX_UPDATER="1";
    VKD3D_CONFIG="dxr,dxr11";
    VKD3D_FEATURE_LEVEL="12_1";

    # gcc parameters
    COMMON_FLAGS="-march=native -O2 -pipe";
    CFLAGS="$COMMON_FLAGS";
    CXXFLAGS="$COMMON_FLAGS";
    FCFLAGS="$COMMON_FLAGS";
    FFFLAGS="$COMMON_FLAGS";
    MAKEOPTS="-j17";

    ## XDG  
    XDG_RUNTIME_DIR="/run/user/$UID";

    ## XDG Derivated
    ANDROID_HOME="$HOME/Android/Sdk";
    NDK_ROOT="$ANDROID_HOME/Sdk/ndk";
    CUDA_CACHE_PATH="$XDG_CACHE_HOME/nv";
    GNUPGHOME= xdg.dataHome + "/gnupg";
    GRADLE_USER_HOME= xdg.dataHome + "/gradle";
    KDEHOME="$XDG_CONFIG_HOME/kde";
    NODE_REPL_HISTORY= xdg.dataHome + "/node_repl_history";
    NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc";
    DVDCSS_CACHE= xdg.dataHome + "/dvdcss";
    NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages";
    _JAVA_OPTIONS="-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java";
    BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle";
    BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle";
    BUNDLE_USER_PLUGIN= xdg.dataHome + "/bundle";
    XINITRC="$XDG_CONFIG_HOME/X11/xinitrc";
    #ZDOTDIR="$HOME/.config/zsh";
    HISTFILE="$XDG_STATE_HOME/zsh/history";
    GOPATH= xdg.dataHome + "/go";
    GEM_HOME= xdg.dataHome + "/gem";
    GEM_SPEC_CACHE="$XDG_CACHE_HOME/gem";
    GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc";
  };

  ############################################################
  # Default Browser and E-Mail Client
  ############################################################

  programs.firefox = {
    enable = true;
    languagePacks = ["en-GB" "es-ES" "jp-JP"];
  };

  programs.thunderbird = {
    enable = true;
    # languagePacks = ["en-GB" "es-ES" "jp-JP"]; #DELETE?
    profiles.default = {
      isDefault = true;
    };
  };

  ############################################################
  # Multimedia
  ############################################################
  
  services.easyeffects.enable = true;
  
  #programs.pavucontrol.enable = true;

  programs.mpv = {
    enable = true;
   # enableYoutubeDl = true;
    config = {
      profile = "gpu-hq";
      scale="ewa_lanczossharp";
      cscale="ewa_lanczossharp";
      dscale="ewa_lanczossharp";

      interpolation="yes";
      tscale="oversample";
      video-sync="display-resample";
      screenshot-directory="~/Pictures/mpv-screenshots/";
    };
  };

  #programs.youtube-dl.enable = true;

  programs.obs-studio.enable = true;

  ############################################################
  # Security and Integration
  ############################################################

  programs.keepassxc.enable = true;

  ############################################################
  # Documents, Notes and Productivity
  ############################################################

  programs.obsidian.enable = true;

  ############################################################
  # File sharing
  ############################################################

  services.syncthing = {
    enable = true;
    tray.enable = true;
  };

  programs.rclone.enable = true;

  ############################################################
  # CLI Tools
  ############################################################
  home.packages = with pkgs; [
    # Game Engines
    godot_4-mono
    unityhub

    # C / C++
    gcc
    gdb
    cmake
    meson
    ninja

    # C# / .NET
    dotnet-sdk_8
    dotnet-runtime_8
    mono

    # Web / Next.js
    nodejs_20
    yarn
    pnpm

    android-tools
    jdk17

    # Graphics / GameDev
    blender
    renderdoc
    shaderc
    glfw
    glm

    # Multimedia
    audacity
    gimp
    davinci-resolve ## Too Big for VM.
    feh
    ffmpeg
    imagemagick
    inkscape
    krita
    mediainfo-gui
    mediainfo

    # Communication
    discord

    # Gaming
    protonup-qt

    # Reverse Engineering
    ghidra
    imhex

    # Utilities
    ripgrep
    lm_sensors
    fd
    htop
    screen
    rdiff-backup
    sqlitebrowser
    
    # Archives
    unzip
    p7zip
    xz

    # Virtualization
    virt-manager
    virt-viewer
    qemu
    libvirt
    spice
    spice-gtk
    virtio-win
    swtpm

    ## KDE Stuff
    kdePackages.wallpaper-engine-plugin

    ## Guitar
    # Utils
    guitarix
    #tuxguitar ## Fails to build
    # Rocksmith 2014 / WineASIO
    helvum # Lets you view pipewire graph and connect IOs
  ];

  ############################################################
  # Virtualization
  ############################################################
  ## FIX AFTER
  # virt-manager config directory
  #xdg.configFile."libvirt/libvirt.conf".text = ''
  #  uri_default = "qemu:///system"
  #'';

  # Optional QEMU user config
  #xdg.configFile."qemu/bridge.conf".text = ''
  #  allow virbr0
  #'';

  ############################################################
  # Git
  ############################################################
  programs.git = {
    enable = true;
    userName = "Gabriel Bustillo del Cuvillo";
    userEmail = "me@gabusuv.dev";
    lfs.enable = true;
  };

  ############################################################
  # VS Code (Extensions)
  ############################################################
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
      ms-vscode.cpptools
      ms-vscode.cmake-tools
      # ms-vscode.vscode-typescript-next ## TODO | FIXME
      esbenp.prettier-vscode
      eamodio.gitlens
      # ms-vscode.unreal-engine ## TODO | FIXME
    ];
  };

  ############################################################
  # Vim (CLI editor)
  ############################################################
  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      number = true;
      expandtab = true;
      shiftwidth = 2;
    };
  };

  ############################################################
  # Desktop Integration
  ############################################################
  
}