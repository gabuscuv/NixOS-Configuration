{ pkgs }:

pkgs.mkShell {
  name = "unreal-engine-shell";

  packages = with pkgs; [
    clang
    lld
    cmake
    ninja
    mono
    dotnet-sdk_8
    jdk11
    android-sdk
    android-ndk
    vulkan-loader
    vulkan-tools
    git
    git-lfs
  ];

  shellHook = ''
    export UE_SDKS_ROOT=$PWD/.ue-sdks
    export JAVA_HOME=${pkgs.jdk11}
    echo "🎮 Unreal Engine devShell loaded"
  '';
}
