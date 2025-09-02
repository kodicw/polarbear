{ pkgs
, lib
, config
, ...
}:
let
  namespace = "sec";
  cfg = config.${namespace}.antivirus;
in
{
  options.${namespace}.antivirus = {
    enable = lib.mkEnableOption "ClamAV";
  };

  config = lib.mkIf cfg.enable {
    services.clamav = {
      daemon = {
        enable = true;
      };
      fangfrisch = {
        enable = true;
      };
      scanner = {
        enable = true;
        scanDirectories = [
          "/home"
          "/var/lib"
          "/tmp"
          "/etc"
          "/var/tmp"
        ];
      };
    };
  };
}
