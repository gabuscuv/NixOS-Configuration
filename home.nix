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
      plugins = [git];
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
    wget = "wget --hsts-file=\"$XDG_DATA_HOME/wget-hsts\"";
  };

  home.sessionVariables = {
    # PATH=$PATH:$HOME/.local/bin:$HOME/.dotnet:$HOME/.npm-global/bin:/var/lib/flatpak/exports/bin:$GEM_HOME/ruby/2.7.0/bin:$HOME/.dotnet/tools:$GOPATH/bin;
    # WINE Stuff
    WINEPREFIX="$XDG_DATA_HOME/wine";
    WINEPREFIX32="$XDG_DATA_HOME/wine32";
    
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
    GNUPGHOME="$XDG_DATA_HOME/gnupg";
    GRADLE_USER_HOME="$XDG_DATA_HOME/gradle";
    KDEHOME="$XDG_CONFIG_HOME/kde";
    NODE_REPL_HISTORY="$XDG_DATA_HOME/node_repl_history";
    NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc";
    DVDCSS_CACHE="$XDG_DATA_HOME/dvdcss";
    NUGET_PACKAGES="$XDG_CACHE_HOME/NuGetPackages";
    _JAVA_OPTIONS="-Djava.util.prefs.userRoot=\"$XDG_CONFIG_HOME\"/java";
    BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle";
    BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle";
    BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle";
    XINITRC="$XDG_CONFIG_HOME/X11/xinitrc";
    ZDOTDIR="$HOME/.config/zsh";
    HISTFILE="$XDG_STATE_HOME/zsh/history";
    GOPATH="$XDG_DATA_HOME/go";
    GEM_HOME="$XDG_DATA_HOME/gem";
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
    # Editors
    vscode

    # Game Engines
    godot_4-mono
    unityhub

    # C / C++
    gcc
    #clang # Use in shell envioriments
    #clang-tools # Use in shell envioriments
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
    #android-sdk ## TODO | FIXME
    #android-ndk ## TODO | FIXME
    #gradle  # Use in shell envioriments
    jdk17
    #jdk11  # Use in shell envioriments

    # Graphics / GameDev
    blender
    renderdoc
    shaderc
    glfw
    glm

    # Multimedia
    gimp
    mpv
    feh

    # Utilities
    ripgrep
    fd
    htop
    tmux
    unzip

    # Virtualization
    virt-manager
    virt-viewer
    qemu
    libvirt
    spice
    spice-gtk
    virtio-win
    swtpm

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