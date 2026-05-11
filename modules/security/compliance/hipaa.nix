{ lib
, config
, ...
}:
let
  cfg = config.sec.compliance.hipaa;
in
{
  options.sec.compliance.hipaa = {
    enable = lib.mkEnableOption "HIPAA compliance implementation guide";
  };

  config = lib.mkIf cfg.enable {
    # 1. Encryption
    services.tailscale.enable = lib.mkDefault true;
    security.fips.enable = lib.mkDefault true;

    # 2. Access Control (Mapped to HIPAA Requirements)
    sec.requirements.access-control = {
      ssh-no-root.enable = lib.mkDefault true;
      ssh-no-password.enable = lib.mkDefault true;
      sudo-wheel-only.enable = lib.mkDefault true;
    };

    # 3. Auditing & Logging
    sec.requirements.auditing = {
      identity-changes.enable = lib.mkDefault true;
      privileged-commands.enable = lib.mkDefault true;
      privilege-escalation.enable = lib.mkDefault true;
      network-activity.enable = lib.mkDefault true;
      file-access-failures.enable = lib.mkDefault true;
    };

    services.journald.extraConfig = ''
      ForwardToSyslog=yes
      MaxLevelStore=info
    '';

    # 4. System Hardening
    sec.requirements.hardening = {
      kernel-parameters.enable = lib.mkDefault true;
      apparmor.enable = lib.mkDefault true;
      vuln-scanning.enable = lib.mkDefault true;
    };

    networking.firewall.enable = lib.mkDefault true;

    # 5. Vulnerability Management
    system.autoUpgrade = {
      enable = lib.mkDefault true;
      allowReboot = lib.mkDefault false;
      dates = lib.mkDefault "04:00";
    };
  };
}
