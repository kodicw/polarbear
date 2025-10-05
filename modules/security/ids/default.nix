{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.sec.bestPractices.ids;
in
{
  options.sec.bestPractices.ids = {
    enable = lib.mkEnableOption "Intrusion Detection System (Suricata)";
  };

  config = lib.mkIf cfg.enable {
    services.suricata.enable = true;

    systemd.services.suricata-update = {
      description = "Update Suricata rules";
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.suricata}/bin/suricata-update";
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
    };

    systemd.timers.suricata-update = {
      description = "Update Suricata rules daily";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };

    environment.systemPackages = [ pkgs.suricata ];
  };
}
