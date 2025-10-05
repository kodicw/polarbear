{ lib
, config
, ...
}:
let
  namespace = "security";
  module_name = "compliance";
  cfg = config.${namespace}.${module_name};
in
{
  options.${namespace}.${module_name} = {
    enable = lib.mkEnableOption "ClamAV";
  };

  config = lib.mkIf cfg.enable {
        security = {
          auditd.enable = true;
          audit = {
            enable = true;
            rules = [
              # =================================================================
              # Control Rules: Manage how the audit system operates
              # =================================================================
              "-D" # Clear all previous rules
              "-b 8192" # Set max backlog to 8192
              "-f 1" # Log on failure (don't halt the system)

              # =================================================================
              # File and Directory Auditing (System-critical files)
              # =================================================================
              # Audit changes to system binaries and configuration files
              "-w /etc/group -p wa -k identity_change"
              "-w /etc/passwd -p wa -k identity_change"
              "-w /etc/gshadow -p wa -k identity_change"
              "-w /etc/shadow -p wa -k identity_change"
              "-w /etc/security/opasswd -p wa -k identity_change"
              "-w /etc/sudoers -p wa -k privileged_command"
              "-w /etc/sudoers.d/ -p wa -k privileged_command"
              "-w /etc/profile -p wa -k system_config"
              "-w /etc/bashrc -p wa -k system_config"
              "-w /etc/csh.cshrc -p wa -k system_config"
              "-w /etc/login.defs -p wa -k system_config"
              "-w /etc/securetty -p wa -k system_config"
              "-w /etc/ssh/sshd_config -p wa -k ssh_config"
              "-w /etc/crontab -p wa -k cron_change"
              "-w /etc/anacrontab -p wa -k cron_change"
              "-w /etc/cron.d/ -p wa -k cron_change"
              "-w /etc/cron.daily/ -p wa -k cron_change"
              "-w /etc/cron.hourly/ -p wa -k cron_change"
              "-w /etc/cron.monthly/ -p wa -k cron_change"
              "-w /etc/cron.weekly/ -p wa -k cron_change"

              # Audit changes to the Nix store and system paths (NixOS specific)
              # This is critical for integrity on NixOS
              "-w /nix/store -p wa -k nix_store_change"
              "-w /run/current-system/sw/bin/ -p wa -k nix_bin_change"

              # =================================================================
              # System Call Auditing (Privilege escalation, module loading, etc.)
              # =================================================================
              # Monitor for privilege escalation attempts
              "-a always,exit -F arch=b64 -S execve,execveat -F a0=0 -F a1=0 -F a2=0 -F key=no-execve-args"
              "-a always,exit -F arch=b64 -S chmod,fchmod,fchmodat -F auid>=1000 -F auid!=4294967295 -k perm_change"
              "-a always,exit -F arch=b64 -S chown,fchown,lchown,fchownat -F auid>=1000 -F auid!=4294967295 -k owner_change"
              "-a always,exit -F arch=b64 -S setuid,setgid,seteuid,setegid,setreuid,setregid -k privilege_change"
              "-a always,exit -F arch=b64 -S usermod -k user_change"

              # Monitor for changes to users, groups, and passwords
              "-a always,exit -F arch=b64 -S useradd,groupadd,groupmod,usermod,passwd -k account_change"

              # Monitor for module loading and unloading
              "-a always,exit -F arch=b64 -S init_module,finit_module,delete_module -k module_change"

              # Monitor for attempts to modify the system time
              "-a always,exit -F arch=b64 -S adjtimex,settimeofday,stime,clock_settime -k time_change"

              # Monitor for network connection attempts
              "-a always,exit -F arch=b64 -S bind,listen,connect -k network_change"

              # Monitor for successful and failed file access attempts
              "-a always,exit -F arch=b64 -S openat,open,creat -F exit=-EACCES -k access_failed"
              "-a always,exit -F arch=b64 -S openat,open,creat -F exit=-EPERM -k access_failed"

              # Monitor for file deletions
              "-a always,exit -F arch=b64 -S unlink,unlinkat,rmdir -k file_deletion"
            ];
          };
          apparmor = {
            enable = true;
            enableCache = true;
          };
        };
      };
}
