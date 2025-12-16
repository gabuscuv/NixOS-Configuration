{ config, pkgs, ... }:

{
  home.username = "gabuscuv";
  home.homeDirectory = "/home/gabuscuv";
  home.stateVersion = "25.11";

  ############################################################
  # Shell
  ############################################################
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
  };

  oh-my-zsh = {
    enable = true;
    plugins = [ ];
    theme = "agnoster";
  };

  ############################################################
  # CLI Tools
  ############################################################
  home.packages = with pkgs; [
    # Editors
    vscode
    vim

    # Game Engines
    godot_4-mono
    unityhub

    # C / C++
    gcc
    clang
    clang-tools
    gdb
    cmake
    meson
    ninja

    # C# / .NET
    dotnet-sdk_8
    dotnet-runtime_8
    mono

    # Web / Next.js
    nodejs_20
    yarn
    pnpm

    android-tools
    android-sdk
    android-ndk
    gradle
    jdk17
    jdk11

    # Graphics / GameDev
    blender
    renderdoc
    shaderc
    glfw
    glm

    # Utilities
    ripgrep
    fd
    htop
    tmux
    unzip
  ];

  ############################################################
  # Git
  ############################################################
  programs.git = {
    enable = true;
    userName = "Gabriel Bustillo del Cuvillo";
    userEmail = "me@gabusuv.dev";
    lfs.enable = true;
  };

  ############################################################
  # VS Code (Extensions)
  ############################################################
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      ms-dotnettools.csharp
      ms-vscode.cpptools
      ms-vscode.cmake-tools
      ms-vscode.vscode-typescript-next
      esbenp.prettier-vscode
      eamodio.gitlens
      ms-vscode.unreal-engine
    ];
  };

  ############################################################
  # Vim (CLI editor)
  ############################################################
  programs.vim = {
    enable = true;
    defaultEditor = true;
    settings = {
      number = true;
      expandtab = true;
      shiftwidth = 2;
    };
  };
}