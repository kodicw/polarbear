{ pkgs, ... }:
pkgs.buildEnv {
  name = "ssh-tools";
  paths = with pkgs; [
    mosh
    sshfs
    wishlist
  ];
}
