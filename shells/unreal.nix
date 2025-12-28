{
  pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  },
}:
let
  stdenv = pkgs.llvmPackages_20.stdenv;
  lib = pkgs.lib;

  nixConfig.allow-unfree = true;

  ## Unreal Android Development / VR Untethered Development
  androidVersion = "33.0.2";

  androidSdk =
    (pkgs.androidenv.composeAndroidPackages {
      platformVersions = [ "33" ];
      includeNDK = true;
      ndkVersion = "25.1.8937393";
      cmakeVersions = [ "3.22.1" ];
      # it supposed to be 33.0.2 but... set it to lowest available to avoid broken dependencies
      platformToolsVersion = "35.0.1";
      buildToolsVersions = [ androidVersion ];
    }).androidsdk;

  dotnetPkg =
    with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_8_0
    ];
  deps = with pkgs; [
    zlib
    zlib.dev
    openssl
    dotnetPkg
    androidSdk
  ];
  # userEnv = lib.attrsets.mergeAttrsList ([] ++ (lib.optional (builtins.pathExists ./env.nix) (import ./env.nix)));
  currentShell = builtins.getEnv "SHELL";
  currentFHS = builtins.getEnv "FHS_CURRENT";
in
(pkgs.buildFHSEnv {
  name = "UnrealEditor";
  allowUnfree = true;
  targetPkgs =
    pkgs:
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
      vulkan-loader
      vulkan-tools
      wayland
      git
      git-lfs
      ## Tethered VR Development
      openxr-loader
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

  NIX_LD_LIBRARY_PATH = lib.makeLibraryPath (
    [
      stdenv
    ]
    ++ deps
  );
  NIX_LD = "${stdenv.cc.libc_bin}/bin/ld.so";
  nativeBuildInputs = deps;

  profile = ''
    export FHS_CURRENT="${currentFHS}"
    export DOTNET_ROOT="${dotnetPkg}"
    export ANDROID_HOME=${androidSdk}
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    STUDIO_SDK_PATH="$ANDROID_HOME"
    export ANDROID_USER_HOME="$HOME/.android"
    export ANDROID_AVD_HOME="$HOME/.android/avd"
    export LD_LIBRARY_PATH=/usr/lib:/usr/lib32
    export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
  ''; # + lib.strings.concatStrings (lib.attrsets.mapAttrsToList (name: value: ''export ${name}="${value}"'') userEnv);
}).env
