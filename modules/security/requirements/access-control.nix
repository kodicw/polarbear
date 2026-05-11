{ lib
, config
, ...
}:
{
  options.sec.requirements.access-control = {
    ssh-no-root = {
      enable = lib.mkEnableOption "Restrict direct root SSH login";
      description = ''
        Disables direct root access via SSH. Root logins are prohibited 
        even with cryptographic keys, requiring an initial login by 
        an unprivileged user and then an explicit switch to root.
      '';
    };
    ssh-no-password = {
      enable = lib.mkEnableOption "Restrict SSH password-based authentication";
      description = ''
        Disables all password-based and keyboard-interactive authentication methods for SSH.
        Only cryptographic keys are permitted for authentication, significantly reducing the
        effectiveness of brute-force and credential-stuffing attacks.
      '';
    };
    sudo-wheel-only = {
      enable = lib.mkEnableOption "Restrict sudo execution to members of the wheel group";
      description = ''
        Configures sudo to only allow members of the wheel group to execute commands.
        Limits the surface area of potential privilege escalation by narrowing down 
        the list of users that can even attempt a sudo operation.
      '';
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.sec.requirements.access-control.ssh-no-root.enable {
      services.openssh.settings.PermitRootLogin = lib.mkForce "no";
    })
    (lib.mkIf config.sec.requirements.access-control.ssh-no-password.enable {
      services.openssh.settings.PasswordAuthentication = lib.mkForce false;
      services.openssh.settings.KbdInteractiveAuthentication = lib.mkForce false;
    })
    (lib.mkIf config.sec.requirements.access-control.sudo-wheel-only.enable {
      security.sudo.execWheelOnly = lib.mkForce true;
    })
  ];
}
