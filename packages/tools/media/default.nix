{ pkgs, ... }:
pkgs.buildEnv {
  name = "media-tools";
  paths = with pkgs; [
    mpv
    motion
    ytfzf
    pamixer
    ffmpeg-full
  ];
}
