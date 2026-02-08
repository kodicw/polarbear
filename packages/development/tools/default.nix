{ pkgs, ... }:
pkgs.buildEnv {
  name = "dev-tools";
  paths = with pkgs; [
    bruno
    bun
    chromedriver
    devenv
    ffmpeg
    fzf
    gcc
    git
    go
    just
    lazydocker
    lazygit
    lazysql
    lua
    minicom
    nim
    nodejs
    pixi
    quickemu
    thonny
    uv
  ];
}
