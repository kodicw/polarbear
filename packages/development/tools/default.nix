{ pkgs, ... }:
pkgs.buildEnv {
  name = "dev-tools";
  paths = with pkgs; [
    git
    chromedriver
    uv
    fzf
    minicom
    ffmpeg
    bruno
    just
    lazysql
    lazydocker
    lazygit
    lua
    pixi
    go
    gcc
    bun
    nodejs
    nim
    quickemu
    thonny
  ];
}
