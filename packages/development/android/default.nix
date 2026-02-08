{ pkgs, ... }:
pkgs.buildEnv {
  name = "android-tools";
  paths = with pkgs; [
    scrcpy
    adbtuifm
    adb-sync
    adbfs-rootless
  ];
}
