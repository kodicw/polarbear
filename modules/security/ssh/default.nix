{ lib
, config
, ...
}:
let
  cfg = config.sec.bestPractices.ssh;
in
{
  options.sec.bestPractices.ssh = {
    enable = lib.mkEnableOption "SSH hardening";
    allowedUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "charles" ];
      description = "Users allowed to SSH";
    };
    port = lib.mkOption {
      type = lib.types.int;
      default = 22;
      description = "SSH port";
    };
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      settings = {
        PermitRootLogin = "prohibit-password";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        AllowUsers = cfg.allowedUsers;
        X11Forwarding = false;
        MaxAuthTries = 3;
        LoginGraceTime = 30;
        ClientAliveInterval = 300;
        ClientAliveCountMax = 2;
      };
      extraConfig = ''
        AllowAgentForwarding no
        AllowTcpForwarding no
        AuthenticationMethods publickey
      '';
    };
  };
}
