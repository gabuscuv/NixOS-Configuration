#!/bin/sh
DEVSHELLS_ROOT_PATH=/etc/nixos/shells
ROOT_PATH=$HOME/git
mkdir -p $ROOT_PATH/UnrealProjects
cp ./envrcs/unreal $ROOT_PATH/UnrealProjects/.envrc

mkdir -p $ROOT_PATH/UnityProjects
echo "use flake $DEVSHELLS_ROOT_PATH#unity" > $ROOT_PATH/UnityProjects/.envrc
mkdir -p $ROOT_PATH/Unity6Projects
echo "use flake $DEVSHELLS_ROOT_PATH#unity6" > $ROOT_PATH/Unity6Projects/.envrc
mkdir -p $ROOT_PATH/GodotProjects
echo "use flake $DEVSHELLS_ROOT_PATH#godot" > $ROOT_PATH/GodotProjects/.envrc
