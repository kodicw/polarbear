{ pkgs, ... }:
pkgs.buildEnv {
  name = "gaming";
  paths = with pkgs; [
    steam
    protontricks
    bottles
  ];
}
