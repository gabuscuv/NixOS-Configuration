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
  androidVersion = "34.0.0";
  androidSdk =
    (pkgs.androidenv.composeAndroidPackages {
      platformVersions = [ "34" ];
      cmdLineToolsVersion = "6.0";
      includeNDK = true;
      ndkVersion = "23.1.7779620"; # r23b
      cmakeVersions = [ "3.22.1" ];
      # it supposed to be 34.0.0 but... set it to lowest available to avoid broken dependencies
      platformToolsVersion = "35.0.1";
      buildToolsVersions = [ androidVersion ];
    }).androidsdk;
in
pkgs.mkShell {
  name = "unity-shell";

  packages = with pkgs; [
    unityhub
    jdk11
    gradle
    dotnet-sdk_8
  ];

  shellHook = ''
    export ANDROID_SDK_ROOT=${androidSdk}
    export JAVA_HOME=${pkgs.jdk11}
    echo "🔷 Unity devShell loaded"
  '';
}
