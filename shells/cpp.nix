{
  pkgs ? import <nixpkgs> { },
}:

pkgs.mkShell {
  name = "cpp-dev-shell";

  nativeBuildInputs = with pkgs; [
    cmake
    pkg-config
  ];

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
    gtest
    systemd
    udev
  ];

  shellHook = ''
    echo "🛠️  C++ development shell"
    echo "Compiler: $(g++ --version | head -n1)"
  '';
}
