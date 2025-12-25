{pkgs ? import <nixpkgs> {}}: let
  stdenv = pkgs.llvmPackages_20.stdenv;
  lib = pkgs.lib;
  dotnetPkg = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
    ];
  deps = with pkgs; [
    zlib
    zlib.dev
    openssl
    dotnetPkg
  ];
  # userEnv = lib.attrsets.mergeAttrsList ([] ++ (lib.optional (builtins.pathExists ./env.nix) (import ./env.nix)));
  currentShell = builtins.getEnv "SHELL";
  currentFHS = builtins.getEnv "FHS_CURRENT";
in
(
  pkgs.buildFHSEnv {
    name = "UnrealEditor";
  targetPkgs = pkgs:
      (with pkgs; [
        udev
        alsa-lib
        mono
        dotnet-sdk
        stdenv
        clang_20
        icu
        openssl
        zlib
        sdl3
        sdl3.dev
        sdl3-image
        sdl3-ttf
        vulkan-loader
        vulkan-tools
        vulkan-validation-layers
        glib
        libxkbcommon
        nss
        nspr
        atk
        mesa
        dbus
        pango
        cairo
        libpulseaudio
        libGL
        libgbm
        expat
        libdrm
        dotnet-sdk_8
        jdk11
        #android-sdk
        #android-ndk
        vulkan-loader
        vulkan-tools
        wayland
        git
        git-lfs
      ])
      ++ (with pkgs.xorg; [
        libICE
        libSM
        libX11
        libxcb
        libXcomposite
        libXcursor
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

    runScript = "zsh";

    extraBwrapArgs = [
      "--bind-try /etc/nixos /etc/nixos"
    ];

    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath ([
        stdenv
      ]
      ++ deps);
    NIX_LD = "${stdenv.cc.libc_bin}/bin/ld.so";
    nativeBuildInputs = deps;

    profile = ''
      export FHS_CURRENT="${currentFHS}"
      export DOTNET_ROOT="${dotnetPkg}"
      export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    ''; # + lib.strings.concatStrings (lib.attrsets.mapAttrsToList (name: value: ''export ${name}="${value}"'') userEnv);
  }
).env

