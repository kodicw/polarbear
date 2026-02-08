{ pkgs, ... }:
pkgs.buildEnv {
  name = "software-reverse-engineering";
  paths = with pkgs; [
    ghidra
    mitmproxy2swagger
  ];
}
