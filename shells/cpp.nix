{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "cpp-dev-shell";

  buildInputs = with pkgs; [
    gcc
    gdb
    cmake
    ninja
    autoconf
    automake
    libtool
    pkg-config-unwrapped
    clang-tools
    valgrind
    systemd
  ];

  shellHook = ''
    echo "🛠️  C++ development shell"
    echo "Compiler: $(g++ --version | head -n1)"
  '';
}
