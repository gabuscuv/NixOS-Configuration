{ pkgs }:

pkgs.mkShell {
  name = "godot-shell";

  packages = with pkgs; [
    godot_4-mono
    dotnet-sdk_8
    jdk17
    scons
    pkg-config
  ];

  shellHook = ''
    export JAVA_HOME=${pkgs.jdk17}
    echo "🧩 Godot (Mono) devShell loaded"
  '';
}
