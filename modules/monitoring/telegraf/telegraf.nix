{ config
, pkgs
, lib
, ...
}:
let
  namespace = "monitoring";
  cfg = config.${namespace}.services.telegraf;
in
{
  options = {
    ${namespace}.services.telegraf = {
      enable = lib.mkEnableOption "Enable telegraf";
      urls = with lib; mkOption {
        type = with types; listOf str;
        default = [ "http://127.0.0.1:8086" ];
        description = "List of urls for influxdb api";
      };
    };
  };
  config = lib.mkIf cfg.enable {
    systemd.services.telegraf.path = [ pkgs.iproute2 ];
    services.telegraf = {
      enable = true;
      extraConfig = {
        inputs = {
          netstat = { };
          socketstat = {
            protocols = [ "tcp" "udp" ];
          };
          cpu = { };
          mem = { };
          disk = { };
          processes = { };
          # smart = { };
          system = { };
          systemd_units = { };
        };
        outputs = {
          influxdb_v2 = {
            urls = cfg.urls;
          };
        };
      };
    };
  };
}

