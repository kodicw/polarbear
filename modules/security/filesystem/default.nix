{ lib
, config
, ...
}:
let
  cfg = config.sec.bestPractices.filesystem;
in
{
  options.sec.bestPractices.filesystem = {
    enable = lib.mkEnableOption "Filesystem hardening";
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/tmp" = {
      device = "tmpfs";
      fsType = "tmpfs";
      options = [ "mode=1777" "strictatime" "nosuid" "nodev" "noexec" "size=2G" ];
    };

    boot.tmp.cleanOnBoot = true;
    boot.tmp.useTmpfs = true;
  };
}
