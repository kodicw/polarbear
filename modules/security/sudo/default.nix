{ lib
, config
, pkgs
, ...
}:
let
  cfg = config.sec.bestPractices.sudo;
in
{
  options.sec.bestPractices.sudo = {
    enable = lib.mkEnableOption "Sudo and privilege hardening";
  };

  config = lib.mkIf cfg.enable {
    security.sudo = {
      enable = true;
      execWheelOnly = true;
      extraConfig = ''
        Defaults use_pty
        Defaults logfile=/var/log/sudo.log
        Defaults log_input,log_output
        Defaults lecture=always
        Defaults passwd_timeout=1
        Defaults timestamp_timeout=5
        Defaults insults
      '';
    };

    security.pam.services.sudo.requireWheel = true;
    security.pam.loginLimits = [
      { domain = "*"; type = "hard"; item = "core"; value = "0"; }
      { domain = "*"; type = "hard"; item = "nproc"; value = "1000"; }
    ];
  };
}
