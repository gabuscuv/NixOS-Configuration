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
  androidVersion = "36.0.0";
  androidSdk =
    (pkgs.androidenv.composeAndroidPackages {
      platformVersions = [ "36" ];
      cmdLineToolsVersion = "16.0";
      includeNDK = true;
      ndkVersion = "27.2.12479018"; # r27c
      cmakeVersions = [ "3.22.1" ];
      platformToolsVersion = androidVersion;
      buildToolsVersions = [ androidVersion ];
    }).androidsdk;
in
pkgs.mkShell {
  name = "unity-shell";

  packages = with pkgs; [
    unityhub
    jdk17
    gradle
    dotnet-sdk_8
  ];

  shellHook = ''
    export ANDROID_SDK_ROOT=${androidSdk}
    export JAVA_HOME=${pkgs.jdk17}
    echo "🔷 Unity devShell loaded"
  '';
}
