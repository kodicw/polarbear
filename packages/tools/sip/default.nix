{ pkgs, ... }:
pkgs.buildEnv {
  name = "sip-tools";
  paths = with pkgs; [
    sipexer
    baresip
  ];
}
