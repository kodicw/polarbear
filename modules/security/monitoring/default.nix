{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.sec.bestPractices.monitoring;
in
{
  options.sec.bestPractices.monitoring = {
    enable = lib.mkEnableOption "Security monitoring via telegraf";
  };

  config = lib.mkIf cfg.enable {
    services.telegraf.enable = true;
    
    services.telegraf.extraConfig.inputs = {
      auditd = lib.mkIf config.security.auditd.enable [{
        files = [ "/var/log/audit/audit.log" ];
      }];

      fail2ban = lib.mkIf config.services.fail2ban.enable [{ }];

      tail = lib.flatten [
        (lib.optional config.sec.bestPractices.sudo.enable {
          name_override = "sudo_log";
          files = [ "/var/log/sudo.log" ];
          data_format = "grok";
          grok_patterns = [ "%{SYSLOGTIMESTAMP:timestamp} : %{USER:user} : TTY=%{DATA:tty} ; PWD=%{DATA:pwd} ; USER=%{USER:sudo_user} ; COMMAND=%{GREEDYDATA:command}" ];
        })

        (lib.optional config.services.suricata.enable {
          name_override = "suricata_eve";
          files = [ "/var/log/suricata/eve.json" ];
          data_format = "json";
          json_string_fields = [ "event_type" "src_ip" "dest_ip" "proto" ];
        })

        (lib.optional config.services.suricata.enable {
          name_override = "suricata_log";
          files = [ "/var/log/suricata/suricata.log" ];
          data_format = "grok";
          grok_patterns = [ "%{SYSLOGTIMESTAMP:timestamp} - <%{LOGLEVEL:level}> - %{GREEDYDATA:message}" ];
        })
      ];

      syslog = [{
        server = "unix:///var/run/telegraf-syslog.sock";
        best_effort = true;
      }];

      journald = [{
        files = [ "/var/log/journal" ];
      }];

      systemd_units = [{ }];
      
      kernel = [{ }];
      
      netstat = [{ }];

      exec = lib.flatten [
        [{
          commands = [
            "${pkgs.coreutils}/bin/who | ${pkgs.coreutils}/bin/wc -l"
          ];
          data_format = "value";
          data_type = "integer";
          name_override = "active_users";
          interval = "60s";
        }]

        (lib.optional config.services.fail2ban.enable {
          commands = [
            "${pkgs.fail2ban}/bin/fail2ban-client status | ${pkgs.gnugrep}/bin/grep 'Currently banned' | ${pkgs.gawk}/bin/awk '{print $4}'"
          ];
          data_format = "value";
          data_type = "integer";
          name_override = "fail2ban_banned_count";
          interval = "60s";
        })

        (lib.optional config.services.suricata.enable {
          commands = [
            "${pkgs.jq}/bin/jq -r 'select(.event_type==\"stats\") | .stats.capture.kernel_packets' /var/log/suricata/eve.json 2>/dev/null | ${pkgs.coreutils}/bin/tail -1 || echo 0"
          ];
          data_format = "value";
          data_type = "integer";
          name_override = "suricata_packets_captured";
          interval = "60s";
        })

        (lib.optional config.sec.bestPractices.ssh.enable {
          commands = [
            "${pkgs.systemd}/bin/journalctl -u sshd.service --since '5 minutes ago' | ${pkgs.gnugrep}/bin/grep -c 'Failed password' || echo 0"
          ];
          data_format = "value";
          data_type = "integer";
          name_override = "ssh_failed_login_attempts";
          interval = "60s";
        })

        (lib.optional config.networking.nftables.enable {
          commands = [
            "${pkgs.systemd}/bin/journalctl --since '5 minutes ago' | ${pkgs.gnugrep}/bin/grep -c 'nftables drop:' || echo 0"
          ];
          data_format = "value";
          data_type = "integer";
          name_override = "firewall_dropped_packets";
          interval = "60s";
        })
      ];
    };

    services.telegraf.extraConfig.outputs = {
      file = [{
        files = [ "/var/log/telegraf/security-metrics.json" ];
        data_format = "json";
      }];

      socket_writer = [{
        address = "unix:///var/run/telegraf-security.sock";
      }];
    };

    systemd.tmpfiles.rules = [
      "d /var/log/telegraf 0755 telegraf telegraf -"
    ];

    systemd.sockets.telegraf-syslog = {
      description = "Telegraf syslog socket";
      wantedBy = [ "sockets.target" ];
      socketConfig = {
        ListenDatagram = "/var/run/telegraf-syslog.sock";
        SocketMode = "0666";
      };
    };
  };
}
