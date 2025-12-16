{ pkgs }:

pkgs.mkShell {
  name = "unity-shell";

  packages = with pkgs; [
    unityhub
    android-sdk
    android-ndk
    jdk17
    gradle
    dotnet-sdk_8
  ];

  shellHook = ''
    export JAVA_HOME=${pkgs.jdk17}
    echo "🔷 Unity devShell loaded"
  '';
}
