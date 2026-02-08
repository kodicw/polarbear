{ pkgs, ... }:
pkgs.buildEnv {
  name = "red-tools";
  paths = with pkgs; [
    metasploit
  ];
}
