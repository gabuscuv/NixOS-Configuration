{ config, pkgs, ... }:
{
  home.username = "gabuscuv";
  home.homeDirectory = "/home/gabuscuv";
  home.stateVersion = "25.11";

  xdg.enable = true;

  ############################################################
  # Shell
  ############################################################
  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
    shellIntegration.enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "git-lfs"
        "direnv"
        "sudo"
        "vscode"
      ];
      theme = "agnoster";
    };
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
    };
  };

  home.shellAliases = {
    cls = "clear";
    virsh = "virsh -c qemu:///system";
    gitpro = "GIT_SSH_COMMAND='ssh -i ~/.ssh/id_rsa_pro -F /dev/null' git";
    duperemove = "duperemove --hashfile=$HOME/deduperhash.db";
    upgrade = "nix flake update && nixos-rebuild switch";
    # Wine Stuff
    wine64 = "WINEPREFIX=\"$WINEPREFIX\" WINEARCH=win64 wine64";
    wine32 = "WINEPREFIX=\"$WINEPREFIX32\" WINEARCH=win32 wine";
    wine = "wine64";
    ## XDG
    wget = "wget --hsts-file=\"${config.xdg.dataHome}/wget-hsts\"";
  };

  home.sessionVariables = rec {
    # PATH=$PATH:$HOME/.local/bin:$HOME/.dotnet:$HOME/.npm-global/bin:/var/lib/flatpak/exports/bin:$GEM_HOME/ruby/2.7.0/bin:$HOME/.dotnet/tools:$GOPATH/bin;
    # WINE Stuff
    WINEPREFIX = "${config.xdg.dataHome}/wine";
    WINEPREFIX32 = "${config.xdg.dataHome}/wine32";

    ## Gaming Stuff
    PROTON_HIDE_NVIDIA_GPU = "0";
    PROTON_ENABLE_NVAPI = "1";
    PROTON_ENABLE_NGX_UPDATER = "1";
    VKD3D_CONFIG = "dxr,dxr11";
    VKD3D_FEATURE_LEVEL = "12_1";

    # gcc parameters
    COMMON_FLAGS = "-march=native -O2 -pipe";
    CFLAGS = "$COMMON_FLAGS";
    CXXFLAGS = "$COMMON_FLAGS";
    FCFLAGS = "$COMMON_FLAGS";
    FFFLAGS = "$COMMON_FLAGS";
    MAKEOPTS = "-j17";

    ## XDG
    XDG_RUNTIME_DIR = "/run/user/$UID";

    ## XDG Derivated
    ROSLYN_CACHES_DIR = "${config.xdg.cacheHome}/roslyn";
    CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    GRADLE_USER_HOME = "${config.xdg.dataHome}/gradle";
    KDEHOME = "${config.xdg.configHome}/kde";
    NODE_REPL_HISTORY = "${config.xdg.dataHome}/node_repl_history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    DVDCSS_CACHE = "${config.xdg.dataHome}/dvdcss";
    NUGET_PACKAGES = "${config.xdg.cacheHome}/NuGetPackages";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=\"${config.xdg.configHome}\"/java";
    BUNDLE_USER_CONFIG = "${config.xdg.configHome}/bundle";
    BUNDLE_USER_CACHE = "${config.xdg.cacheHome}/bundle";
    BUNDLE_USER_PLUGIN = "${config.xdg.dataHome}/bundle";
    XINITRC = "${config.xdg.configHome}/X11/xinitrc";
    #ZDOTDIR="$HOME/.config/zsh";
    HISTFILE = "${config.xdg.stateHome}/zsh/history";
    GOPATH = "${config.xdg.dataHome}/go";
    GEM_HOME = "${config.xdg.dataHome}/gem";
    GEM_SPEC_CACHE = "${config.xdg.cacheHome}/gem";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };

  ############################################################
  # Default Browser and E-Mail Client
  ############################################################

  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      isDefault = true;
      extensions = {
        packages = with pkgs.nur.repos.rycee.firefox-addons; [
          ublock-origin
          plasma-integration
          privacy-badger
          multi-account-containers
          stylus
        ];
      };
      containers = {
        Otha = {
          id = 1;
          name = "Otha";
        };
        AlterEgo = {
          id = 2;
          name = "AlterEgo";
        };
      };
    };
    profiles.sensitive = {
      id = 1;
      isDefault = false;
    };
    languagePacks = [
      "en-GB"
      "es-ES"
      "jp-JP"
    ];
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
      scale = "ewa_lanczossharp";
      cscale = "ewa_lanczossharp";
      dscale = "ewa_lanczossharp";

      interpolation = "yes";
      tscale = "oversample";
      video-sync = "display-resample";
      screenshot-directory = "~/Pictures/mpv-screenshots/";
    };
  };

  programs.yt-dlp.enable = true;

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
    (unityhub.override {
      extraLibs =
        pkgs: with pkgs; [
          # Without this, the vulkan libs will not be found -> no vulkan
          # renderer in unity (required for HDRP)
          vulkan-loader

          # Pre 2022.3 versions require this:
          # openssl_1_1

          # To ensure unity finds VS Code in its path
          vscode
        ];
    })
    godot_4-mono

    # C# / .NET
    dotnet-sdk_8
    dotnet-runtime_8
    mono

    # Basic Python
    python3Minimal

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
    davinci-resolve # # Too Big for VM.
    feh
    ffmpeg
    imagemagick
    inkscape
    krita
    mediainfo-gui
    mediainfo

    # Communication
    discord
    telegram-desktop

    # Gaming
    protonup-qt

    # Reverse Engineering
    ghidra
    imhex

    # Utilities
    wineWowPackages.full
    nixfmt-rfc-style
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

    # Some hateful libs
    libuuid

    ## KDE Stuff
    kdePackages.plasma-browser-integration

    ## Guitar
    # Utils
    guitarix
    #tuxguitar # Fails to build
    # Rocksmith 2014 / WineASIO
    helvum # Lets you view pipewire graph and connect IOs
  ];

  ############################################################
  # Virtualization
  ############################################################
  # virt-manager config directory
  xdg.configFile."libvirt/libvirt.conf".text = ''
    uri_default = "qemu:///system"
  '';

  # Optional QEMU user config
  xdg.configFile."qemu/bridge.conf".text = ''
    allow virbr0
  '';

  ############################################################
  # Git
  ############################################################
  programs.git = {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "Gabriel Bustillo del Cuvillo";
        email = "me@gabuscuv.dev";
      };
    };
  };

  ############################################################
  # VS Code (Extensions)
  ############################################################
  programs.vscode =
    let
      commonSettings = {
        "workbench.colorTheme" = "Dark+ Pure Black (OLED)";
        "workbench.preferredDarkColorTheme" = "Dark+ Pure Black (OLED)";
        "editor.fontLigatures" = true;
        "editor.renderLineHighlight" = "all";
        "git.autofetch" = true;
        "editor.formatOnSave" = true;
        "terminal.integrated.defaultProfile.linux" = "zsh";
      };

      commonExtensions =
        with pkgs.vscode-extensions;
        [
          eamodio.gitlens
          mkhl.direnv
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "oled-pure-black---vscode";
            publisher = "ChadBaileyVh";
            version = "1.0.1";
            sha256 = "sha256-ukmtfleNJ9ScjSA36Gyok5e8tvzGvveVnCqy+ZV9kPo=";
          }
        ];

      dotNetEnvironment = with pkgs.vscode-extensions; [
        ms-dotnettools.csharp
        ms-dotnettools.vscode-dotnet-runtime
      ];
    in
    {
      enable = true;

      profiles = {
        cpp = {
          userSettings = commonSettings;
          extensions =
            commonExtensions
            ++ (with pkgs.vscode-extensions; [
              ms-vscode.cpptools
              ms-vscode.cmake-tools
            ]);
        };
        dotnet = {
          userSettings = commonSettings;
          extensions = commonExtensions ++ dotNetEnvironment;
        };
        unity = {
          userSettings = commonSettings;
          extensions =
            commonExtensions
            ++ dotNetEnvironment
            ++ (with pkgs.vscode-extensions; [
              ms-dotnettools.csdevkit
              visualstudiotoolsforunity.vstuc
            ]);
        };
        javascript = {
          userSettings = commonSettings;
          extensions =
            commonExtensions
            ++ (with pkgs.vscode-extensions; [
              bradlc.vscode-tailwindcss
              dbaeumer.vscode-eslint
              esbenp.prettier-vscode
              unifiedjs.vscode-mdx
              lokalise.i18n-ally
            ]);
        };
        vanillascript = {
          userSettings = commonSettings;
          extensions =
            commonExtensions
            ++ (with pkgs.vscode-extensions; [
              astro-build.astro-vscode
            ]);
        };
        nix = {
          userSettings = commonSettings;
          extensions =
            commonExtensions
            ++ (with pkgs.vscode-extensions; [
              jnoortheen.nix-ide
            ]);
        };
        godot = {
          userSettings = commonSettings;
          extensions =
            commonExtensions
            ++ dotNetEnvironment
            ++ (with pkgs.vscode-extensions; [
              geequlim.godot-tools
            ]);
        };
        markdown = {
          userSettings = commonSettings;
          extensions =
            commonExtensions
            ++ (with pkgs.vscode-extensions; [
              marp-team.marp-vscode
              yzhang.markdown-all-in-one
              bierner.github-markdown-preview
            ]);
        };
        LaTeX = {
          userSettings = commonSettings;
          extensions =
            commonExtensions
            ++ (with pkgs.vscode-extensions; [
              james-yu.latex-workshop
            ]);
        };
      };
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
  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  xdg.portal = {
    enable = true;

    config = {
      kde.default = [ "kde" ];
      kde."org.freedesktop.portal.FileChooser" = [ "kde" ];
    };

    extraPortals = [
      pkgs.xdg-desktop-portal-termfilechooser

      pkgs.kdePackages.xdg-desktop-portal-kde
    ];
  };

}
