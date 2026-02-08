{ pkgs, ... }:
pkgs.buildEnv {
  name = "desktop-apps";
  paths = with pkgs; [
    banana-cursor
    blender
    discord
    freecad-wayland
    ghostty
    gimp
    gparted
    libreoffice
    localsend
    obs-studio
    proton-pass
    protonmail-desktop
    spotify
    vlc
  ];
}
