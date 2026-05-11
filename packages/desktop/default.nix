{ pkgs, ... }:
pkgs.buildEnv {
  name = "desktop-apps";
  paths = with pkgs; [
    banana-cursor
    blender
    discord
    firefox
    freecad-wayland
    ghostty
    gimp
    gparted
    libreoffice
    localsend
    obs-studio
    proton-pass
    protonmail-desktop
    protonvpn-gui
    rclone-browser
    remmina
    spotify
    vlc
  ];
}
