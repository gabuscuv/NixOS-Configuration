{ pkgs }:

pkgs.mkShell {
  name = "android-shell";

  packages = with pkgs; [
    android-sdk
    android-ndk
    android-tools
    jdk17
    gradle
  ];

  shellHook = ''
    export ANDROID_HOME=${pkgs.android-sdk}/libexec/android-sdk
    export ANDROID_NDK_ROOT=${pkgs.android-ndk}/libexec/android-ndk
    export JAVA_HOME=${pkgs.jdk17}
    echo "🤖 Android devShell loaded"
  '';
}