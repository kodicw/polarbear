{ lib
, config
, ...
}:
let
  cfg = config.sec.bestPractices.fail2ban;
in
{
  options.sec.bestPractices.fail2ban = {
    enable = lib.mkEnableOption "Fail2ban intrusion prevention";
    bantime = lib.mkOption {
      type = lib.types.str;
      default = "1h";
      description = "Ban duration";
    };
    maxretry = lib.mkOption {
      type = lib.types.int;
      default = 3;
      description = "Max retry attempts";
    };
  };

  config = lib.mkIf cfg.enable {
    services.fail2ban = {
      enable = true;
      maxretry = cfg.maxretry;
      bantime = cfg.bantime;
      bantime-increment = {
        enable = true;
        multipliers = "1 2 4 8 16 32 64";
        maxtime = "168h";
        overalljails = true;
      };
      jails.sshd.settings = {
        enabled = true;
        filter = "sshd";
        port = "ssh";
      };
    };
  };
}
