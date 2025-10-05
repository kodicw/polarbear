{ lib
, config
, ...
}:
let
  cfg = config.sec.bestPractices.firewall;
  
  tcpPorts = lib.concatMapStringsSep ", " toString cfg.allowedTCPPorts;
  udpPorts = lib.concatMapStringsSep ", " toString cfg.allowedUDPPorts;
  
  desktopRules = ''
    tcp flags syn tcp option maxseg size 1-536 drop comment "Drop SYN with suspicious MSS"
    
    tcp flags & (fin|syn|rst|ack) == fin|syn drop comment "Drop FIN+SYN packets"
    tcp flags & (fin|syn|rst|ack) == fin|rst drop comment "Drop FIN+RST packets"
    tcp flags & (syn|rst) == syn|rst drop comment "Drop SYN+RST packets"
    tcp flags & (fin|syn) == fin|syn drop comment "Drop FIN+SYN packets"
    tcp flags & (fin|ack) == fin drop comment "Drop FIN without ACK"
    tcp flags & (psh|ack) == psh drop comment "Drop PSH without ACK"
    
    tcp flags & (fin|syn|rst|psh|ack|urg) == 0 drop comment "Drop NULL packets"
    tcp flags & (fin|syn|rst|psh|ack|urg) == fin|syn|rst|psh|ack|urg drop comment "Drop XMAS packets"

    tcp flags syn tcp sport 0-1023 limit rate 1/second burst 5 packets accept comment "Rate limit privileged ports"
  '';
  
  serverRules = ''
    tcp flags syn tcp option maxseg size 1-536 drop comment "Drop SYN with suspicious MSS"
    
    tcp flags & (fin|syn|rst|ack) == fin|syn drop comment "Drop FIN+SYN packets"
    tcp flags & (fin|syn|rst|ack) == fin|rst drop comment "Drop FIN+RST packets"
    tcp flags & (syn|rst) == syn|rst drop comment "Drop SYN+RST packets"
    tcp flags & (fin|syn) == fin|syn drop comment "Drop FIN+SYN packets"
    tcp flags & (fin|ack) == fin drop comment "Drop FIN without ACK"
    tcp flags & (psh|ack) == psh drop comment "Drop PSH without ACK"
    
    tcp flags & (fin|syn|rst|psh|ack|urg) == 0 drop comment "Drop NULL packets"
    tcp flags & (fin|syn|rst|psh|ack|urg) == fin|syn|rst|psh|ack|urg drop comment "Drop XMAS packets"

    tcp flags syn limit rate 100/second burst 200 packets accept comment "SYN flood protection"
    ct state new limit rate 50/second burst 100 packets accept comment "Connection rate limiting"
  '';
in
{
  options.sec.bestPractices.firewall = {
    enable = lib.mkEnableOption "Hardened nftables firewall";
    
    profile = lib.mkOption {
      type = lib.types.enum [ "desktop" "server" ];
      default = "desktop";
      description = "Firewall profile (desktop: strict, server: optimized for services)";
    };
    
    allowedTCPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "Allowed TCP ports";
    };
    
    allowedUDPPorts = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [ ];
      description = "Allowed UDP ports";
    };
    
    allowPing = lib.mkOption {
      type = lib.types.bool;
      default = if cfg.profile == "server" then true else false;
      description = "Allow ICMP ping";
    };
    
    rateLimitPing = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Rate limit ICMP if allowed";
    };
    
    logDropped = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Log dropped packets";
    };
    
    trustedInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "Trusted network interfaces (allow all traffic)";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.enable = false;
    
    networking.nftables = {
      enable = true;
      ruleset = ''
        table inet filter {
          chain input {
            type filter hook input priority filter
            policy drop

            ct state invalid drop comment "Drop invalid connections"
            ct state {established, related} accept comment "Accept established/related"

            iifname lo accept comment "Accept loopback"
            iifname != lo ip daddr 127.0.0.0/8 drop comment "Drop loopback from other interfaces"
            iifname != lo ip6 daddr ::1/128 drop comment "Drop loopback from other interfaces"

            ${lib.optionalString (cfg.trustedInterfaces != []) ''
              iifname { ${lib.concatMapStringsSep ", " (x: ''"${x}"'') cfg.trustedInterfaces} } accept comment "Accept from trusted interfaces"
            ''}

            ${lib.optionalString cfg.allowPing (if cfg.rateLimitPing then ''
              ip protocol icmp icmp type echo-request limit rate 1/second accept comment "Allow ping (rate limited)"
              ip6 nexthdr icmpv6 icmpv6 type echo-request limit rate 1/second accept comment "Allow ping (rate limited)"
            '' else ''
              ip protocol icmp icmp type echo-request accept comment "Allow ping"
              ip6 nexthdr icmpv6 icmpv6 type echo-request accept comment "Allow ping"
            '')}
            
            ${lib.optionalString (cfg.profile == "server") ''
              ip protocol icmp icmp type { destination-unreachable, time-exceeded, parameter-problem } accept comment "Allow ICMP errors"
              ip6 nexthdr icmpv6 icmpv6 type { destination-unreachable, packet-too-big, time-exceeded, parameter-problem } accept comment "Allow ICMPv6 errors"
            ''}

            ${lib.optionalString (cfg.allowedTCPPorts != []) ''
              tcp dport { ${tcpPorts} } ct state new accept comment "Allow specified TCP ports"
            ''}

            ${lib.optionalString (cfg.allowedUDPPorts != []) ''
              udp dport { ${udpPorts} } ct state new accept comment "Allow specified UDP ports"
            ''}

            ${if cfg.profile == "server" then serverRules else desktopRules}

            ${lib.optionalString cfg.logDropped ''
              limit rate 5/minute burst 10 packets log prefix "nftables drop: " level info
            ''}
            
            counter drop comment "Drop all other traffic"
          }

          chain forward {
            type filter hook forward priority filter
            policy drop
            
            ${lib.optionalString cfg.logDropped ''
              limit rate 5/minute burst 10 packets log prefix "nftables forward drop: " level info
            ''}
            
            counter drop
          }

          chain output {
            type filter hook output priority filter
            policy accept
            
            counter accept
          }
        }
      '';
    };
  };
}
