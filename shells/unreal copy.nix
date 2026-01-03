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
      dotnet-sdk
      mono
      jdk11
      stdenv
      clang_20

      # Base libraries
      udev
      zlib
      openssl
      icu

      # SDL2 and multimedia
      SDL2
      SDL2.dev
      SDL2_image
      SDL2_ttf
      SDL2_mixer
      #sdl3
      #sdl3.dev
      #sdl3-image
      #sdl3-ttf

      # Graphics
      vulkan-loader
      vulkan-tools
      vulkan-validation-layers
      libGL
      libdrm
      mesa

      # Audio/Graphics support
      alsa-lib
      libpulseaudio
      libgbm
      libxkbcommon
      expat
      wayland

      # GUI/Windowing
      glib
      dbus
      pango
      cairo
      atk
      gtk3
      nss
      nspr

      ## Version Control
      git
      git-lfs

      ## Tethered VR Development
      openxr-loader
      libuuid

      ## For ANGLE & EGL Troubleshooting
      ungoogled-chromium
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
    unset WAYLAND_DISPLAY
    export FHS_CURRENT="${currentFHS}"
    export DOTNET_ROOT="${dotnetPkg}"
    export ANDROID_HOME=${androidSdk}/libexec/android-sdk 
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    STUDIO_SDK_PATH="$ANDROID_HOME"
    export ANDROID_USER_HOME="$HOME/.android"
    export ANDROID_AVD_HOME="$HOME/.android/avd"

    # See https://gitlab.steamos.cloud/steamrt/steam-runtime-tools/-/blob/main/docs/distro-assumptions.md#graphics-driver
    export LIBGL_DRIVERS_PATH=/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri
    export __EGL_VENDOR_LIBRARY_DIRS=/run/opengl-driver/share/glvnd/egl_vendor.d:/run/opengl-driver-32/share/glvnd/egl_vendor.d
    export __EGL_EXTERNAL_PLATFORM_CONFIG_DIRS=/run/opengl-driver/share/egl/egl_external_platform.d
    export LIBVA_DRIVERS_PATH=/run/opengl-driver/lib/dri:/run/opengl-driver-32/lib/dri
    export VDPAU_DRIVER_PATH=/run/opengl-driver/lib/vdpau:/run/opengl-driver-32/lib/vdpau

    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only

    export LD_LIBRARY_PATH=/usr/lib:/usr/lib32
    export LD_LIBRARY_PATH="${
      pkgs.lib.makeLibraryPath [
        pkgs.libdrm
        pkgs.mesa
        pkgs.libgbm
      ]
    }:$LD_LIBRARY_PATH"

    export SDL_VIDEODRIVER=x11
    export DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
    export NIXOS_OZONE_WL=1

    # GDB Python pretty-printers
    export PYTHONPATH="${pkgs.gcc}/share/gcc-${pkgs.gcc.version}/python:$PYTHONPATH"
  ''; # + lib.strings.concatStrings (lib.attrsets.mapAttrsToList (name: value: ''export ${name}="${value}"'') userEnv);
}).env
