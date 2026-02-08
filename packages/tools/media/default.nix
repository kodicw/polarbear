{ pkgs, ... }:
pkgs.buildEnv {
  name = "media-tools";
  paths = with pkgs; [
    mpv
    motion
    ytfzf
    rclone
    pamixer
    ffmpeg-full
  ];
}
