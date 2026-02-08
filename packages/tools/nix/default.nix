{ pkgs, ... }:
pkgs.buildEnv {
  name = "nix-tools";
  paths = with pkgs; [
    manix
    nixos-anywhere
    nixpkgs-fmt
    nurl
  ];
}
