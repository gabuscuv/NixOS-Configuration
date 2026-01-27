{
  pkgs ? import <nixpkgs> {
    config = {
      allowUnfree = true;
      android_sdk.accept_license = true;
    };
  },
}:
let
  ## Unity Android Development / VR Untethered Development
  androidVersion = "35.0.0";
  androidSdk =
    (pkgs.androidenv.composeAndroidPackages {
      platformVersions = [ "35" ];
      cmdLineToolsVersion = "6.0";
      includeNDK = true;
      ndkVersion = "23.1.7779620"; # r23b
      cmakeVersions = [ "3.22.1" ];
      # it supposed to be 34.0.0 but... set it to lowest available to avoid broken dependencies
      platformToolsVersion = "35.0.1";
      buildToolsVersions = [ androidVersion ];
    }).androidsdk;
  dotnetPkg = (
    with pkgs.dotnetCorePackages;
    combinePackages [
      dotnet_8.sdk
      dotnet_9.sdk
    ]
  );

in
pkgs.mkShell {
  name = "unity-shell";

  packages = with pkgs; [
    unityhub
    jdk11
    dotnetPkg
  ];

  shellHook = ''
    # DotNet
    export DOTNET_ROOT=${dotnetPkg}

    # Android/OpenXR Builds
    export JAVA_HOME=${pkgs.jdk17}
    export ANDROID_HOME=${androidSdk}/libexec/android-sdk 
    export STUDIO_HOME="$ANDROID_HOME"
    export ANDROID_SDK_ROOT="$ANDROID_HOME"
    export STUDIO_SDK_PATH="$ANDROID_HOME"
    export ANDROID_NDK_ROOT=$ANDROID_HOME/ndk/

    export ANDROID_USER_HOME="$HOME/.android"
    export ANDROID_AVD_HOME="$HOME/.android/avd"

    echo "🔷 Unity devShell loaded"
  '';
}
