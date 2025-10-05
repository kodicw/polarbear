{ lib
, config
, ...
}:
let
  cfg = config.sec.bestPractices.network;
in
{
  options.sec.bestPractices.network = {
    enable = lib.mkEnableOption "Network hardening";
    disableIPv6 = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Disable IPv6 if not needed";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.enableIPv6 = lib.mkDefault (!cfg.disableIPv6);
    networking.useDHCP = lib.mkDefault false;
    networking.firewall.logReversePathDrops = true;
    networking.tcpcrypt.enable = false;
  };
}
