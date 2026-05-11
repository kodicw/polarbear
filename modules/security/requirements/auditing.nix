{ lib
, config
, ...
}:
{
  options.sec.requirements.auditing = {
    identity-changes = {
      enable = lib.mkEnableOption "Monitor changes to system identity files";
      description = ''
        Ensures that any modifications to system identity files are logged. 
        This includes /etc/passwd, /etc/group, /etc/shadow, and /etc/gshadow.
        Required for tracking unauthorized user or group creation/modification.
      '';
    };
    privileged-commands = {
      enable = lib.mkEnableOption "Monitor execution of privileged commands";
      description = ''
        Audit changes to sudoers configuration and the use of privileged commands.
        Helps in identifying potential privilege escalation through sudo configuration changes.
      '';
    };
    system-config = {
      enable = lib.mkEnableOption "Monitor changes to core system configuration files";
      description = ''
        Tracks changes to critical system configuration files like /etc/profile, /etc/login.defs, 
        and SSH daemon configurations. This is vital for detecting configuration drift and unauthorized changes.
      '';
    };
    nix-integrity = {
      enable = lib.mkEnableOption "Monitor integrity of the Nix store and system paths";
      description = ''
        NixOS-specific auditing that monitors changes to the /nix/store and current system binaries.
        Since the Nix store should be immutable, any audit events here are highly suspicious.
      '';
    };
    privilege-escalation = {
      enable = lib.mkEnableOption "Monitor for privilege escalation attempts";
      description = ''
        Audits execve system calls and setuid/setgid changes. 
        Focuses on monitoring how processes are executed and how privileges are changed.
      '';
    };
    module-changes = {
      enable = lib.mkEnableOption "Monitor loading and unloading of kernel modules";
      description = ''
        Logs all attempts to load (init_module, finit_module) or unload (delete_module) kernel modules.
        Preventing or auditing module changes is a core part of kernel hardening.
      '';
    };
    time-changes = {
      enable = lib.mkEnableOption "Monitor attempts to modify system time";
      description = ''
        Audits system calls that modify the system clock (adjtimex, settimeofday, etc.).
        Accurate system time is critical for the integrity of audit logs.
      '';
    };
    network-activity = {
      enable = lib.mkEnableOption "Monitor network binding and connection attempts";
      description = ''
        Audits bind, listen, and connect system calls. 
        Provides visibility into which processes are opening network sockets or making outbound connections.
      '';
    };
    file-access-failures = {
      enable = lib.mkEnableOption "Monitor for failed file access attempts";
      description = ''
        Logs all file open/create attempts that fail with EACCES (Permission denied) or EPERM (Operation not permitted).
        High numbers of access failures can indicate an ongoing brute-force or discovery attempt.
      '';
    };
    file-deletions = {
      enable = lib.mkEnableOption "Monitor for file and directory deletions";
      description = ''
        Audits unlink, unlinkat, and rmdir system calls. 
        Provides a trail of what was deleted on the system, which is crucial for forensic analysis.
      '';
    };
  };

  config = {
    security = {
      auditd.enable = lib.mkIf (lib.any (opt: opt.enable) (lib.attrValues config.sec.requirements.auditing)) true;
      audit = {
        enable = lib.mkIf (lib.any (opt: opt.enable) (lib.attrValues config.sec.requirements.auditing)) true;
        rules = lib.flatten [
          (lib.optional config.sec.requirements.auditing.identity-changes.enable [
            "-w /etc/group -p wa -k identity_change"
            "-w /etc/passwd -p wa -k identity_change"
            "-w /etc/gshadow -p wa -k identity_change"
            "-w /etc/shadow -p wa -k identity_change"
            "-w /etc/security/opasswd -p wa -k identity_change"
          ])
          (lib.optional config.sec.requirements.auditing.privileged-commands.enable [
            "-w /etc/sudoers -p wa -k privileged_command"
            "-w /etc/sudoers.d/ -p wa -k privileged_command"
          ])
          (lib.optional config.sec.requirements.auditing.system-config.enable [
            "-w /etc/profile -p wa -k system_config"
            "-w /etc/bashrc -p wa -k system_config"
            "-w /etc/login.defs -p wa -k system_config"
            "-w /etc/securetty -p wa -k system_config"
            "-w /etc/ssh/sshd_config -p wa -k ssh_config"
          ])
          (lib.optional config.sec.requirements.auditing.nix-integrity.enable [
            "-w /nix/store -p wa -k nix_store_change"
            "-w /run/current-system/sw/bin/ -p wa -k nix_bin_change"
          ])
          (lib.optional config.sec.requirements.auditing.privilege-escalation.enable [
            "-a always,exit -F arch=b64 -S execve,execveat -F a0=0 -F a1=0 -F a2=0 -F key=no-execve-args"
            "-a always,exit -F arch=b64 -S setuid,setgid,seteuid,setegid,setreuid,setregid -k privilege_change"
          ])
          (lib.optional config.sec.requirements.auditing.module-changes.enable [
            "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -k module_change"
          ])
          (lib.optional config.sec.requirements.auditing.time-changes.enable [
            "-a always,exit -F arch=b64 -S adjtimex,settimeofday,stime,clock_settime -k time_change"
          ])
          (lib.optional config.sec.requirements.auditing.network-activity.enable [
            "-a always,exit -F arch=b64 -S bind,listen,connect -k network_change"
          ])
          (lib.optional config.sec.requirements.auditing.file-access-failures.enable [
            "-a always,exit -F arch=b64 -S openat,open,creat -F exit=-EACCES -k access_failed"
            "-a always,exit -F arch=b64 -S openat,open,creat -F exit=-EPERM -k access_failed"
          ])
          (lib.optional config.sec.requirements.auditing.file-deletions.enable [
            "-a always,exit -F arch=b64 -S unlink,unlinkat,rmdir -k file_deletion"
          ])
        ];
      };
    };
  };
}
