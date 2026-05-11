{ lib
, config
, ...
}:
let
  cfg = config.sec.stigs.nyx;
in
{
  options.sec.stigs.nyx = {
    enable = lib.mkEnableOption "Pragmatic NYX STIG-inspired hardening profile";
  };

  config = lib.mkIf cfg.enable {
    # Reuse existing best practices
    sec.bestPractices.kernel.enable = lib.mkDefault true;
    sec.bestPractices.ssh.enable = lib.mkDefault true;
    sec.bestPractices.sudo.enable = lib.mkDefault true;
    sec.bestPractices.network.enable = lib.mkDefault true;

    # Enable requirements based on STIG needs
    sec.requirements.auditing = {
      identity-changes.enable = lib.mkDefault true;
      privileged-commands.enable = lib.mkDefault true;
      privilege-escalation.enable = lib.mkDefault true;
      module-changes.enable = lib.mkDefault true;
      file-access-failures.enable = lib.mkDefault true;
    };

    sec.requirements.access-control = {
      ssh-no-root.enable = lib.mkDefault true;
      ssh-no-password.enable = lib.mkDefault true;
      sudo-wheel-only.enable = lib.mkDefault true;
    };

    sec.requirements.hardening = {
      kernel-parameters.enable = lib.mkDefault true;
      apparmor.enable = lib.mkDefault true;
      kernel-lockdown.enable = lib.mkDefault true;
    };
  };
}
