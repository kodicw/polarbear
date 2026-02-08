{ pkgs, ... }:
pkgs.buildEnv {
  name = "cli-tools";
  paths = with pkgs; [
    aspell
    btop
    fastfetch
    nb
    nushell
    proxychains
    tmux
    typer
    zellij
  ];
}
