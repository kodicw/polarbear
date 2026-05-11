{ lib
, config
, ...
}:
{
  options.sec.requirements.hardening = {
    kernel-parameters = {
      enable = lib.mkEnableOption "Harden core kernel parameters";
      description = ''
        Modifies sysctl settings to improve kernel security.
        This includes restricting dmesg and kptr access and 
        hardening the network stack against IP spoofing.
      '';
    };
    apparmor = {
      enable = lib.mkEnableOption "Enable AppArmor mandatory access control";
      description = ''
        Enables AppArmor, a kernel-level Mandatory Access Control (MAC) 
        system that provides strong process-level isolation through 
        per-process profiles.
      '';
    };
    kernel-lockdown = {
      enable = lib.mkEnableOption "Enable kernel lockdown and module locking";
      description = ''
        Locks down the kernel's internal state and prohibits the 
        loading of additional kernel modules after the system has 
        booted. This is a powerful mitigation against post-exploitation
        persistence.
      '';
    };
    vuln-scanning = {
      enable = lib.mkEnableOption "Enable continuous vulnerability scanning";
      description = ''
        Enables security.auditPackages, which regularly checks the 
        system's packages against known vulnerabilities (CVEs) in 
        the NixOS database.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.sec.requirements.hardening.kernel-parameters.enable {
      boot.kernel.sysctl = {
        "kernel.kptr_restrict" = 2;
        "kernel.dmesg_restrict" = 1;
        "net.ipv4.conf.all.rp_filter" = 1;
        "net.ipv4.tcp_syncookies" = 1;
      };
    })
    (lib.mkIf config.sec.requirements.hardening.apparmor.enable {
      security.apparmor = {
        enable = true;
        enableCache = true;
      };
    })
    (lib.mkIf config.sec.requirements.hardening.kernel-lockdown.enable {
      security.lockKernelModules = true;
      security.protectKernelImage = true;
    })
    (lib.mkIf config.sec.requirements.hardening.vuln-scanning.enable {
      security.auditPackages.enable = true;
    })
  ];
}
