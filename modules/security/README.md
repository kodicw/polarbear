# Security Best Practices Modules

Comprehensive NixOS security hardening modules following industry best practices. These are **opt-in** and NOT included in `polarbear.nixosModules.default`.

All modules use the `sec.bestPractices.*` namespace for clarity and organization.

## Usage

### Option 1: Import All Security Modules

```nix
{
  imports = [
    polarbear.nixosModules.security
  ];
  
  sec.bestPractices = {
    ssh = {
      enable = true;
      allowedUsers = [ "charles" ];
      port = 22;
    };
    firewall = {
      enable = true;
      profile = "server";  # or "desktop"
      allowedTCPPorts = [ 22 80 443 ];
      allowedUDPPorts = [ 53 ];
      trustedInterfaces = [ "docker0" ];  # optional
    };
    kernel.enable = true;
    filesystem.enable = true;
    sudo-hardening.enable = true;
    fail2ban-hardening = {
      enable = true;
      bantime = "1h";
      maxretry = 3;
    };
    network = {
      enable = true;
      disableIPv6 = false;
    };
    ids = {
      enable = true;
      interface = "eth0";
      homenet = "[192.168.0.0/16,10.0.0.0/8]";
    };
    antivirus.enable = true;
    compliance.enable = true;
    monitoring.enable = true;
  };
}
```

### Option 2: Import Individual Modules

```nix
{
  imports = [
    polarbear.nixosModules.security-ssh
    polarbear.nixosModules.security-firewall
    polarbear.nixosModules.security-kernel
  ];
  
  sec.bestPractices.ssh.enable = true;
  sec.bestPractices.firewall.enable = true;
  sec.bestPractices.kernel.enable = true;
}
```

## Available Modules

### SSH Hardening (`security-ssh`)
- Disables root login (keys only)
- Disables password authentication
- Modern ciphers and KEX algorithms
- Connection limits and timeouts
- **Options**: `security.ssh.{enable, allowedUsers, port}`

### Firewall (`security-firewall`)
- **nftables-based** hardened firewall ruleset
- **Two profiles**: desktop (strict) and server (service-optimized)
- Default deny inbound, allow outbound policy
- Connection state tracking (established/related)
- Invalid packet dropping
- TCP flag validation (SYN/FIN, NULL, XMAS attacks)
- Rate limiting for ICMP and privileged ports
- **Server profile features:**
  - SYN flood protection (100/s, burst 200)
  - Connection rate limiting (50/s, burst 100)
  - ICMP error messages allowed
  - Ping enabled by default
- Trusted interface support (allow all from specific interfaces)
- Comprehensive logging with rate limits
- **Options**: `sec.bestPractices.firewall.{enable, profile, allowedTCPPorts, allowedUDPPorts, allowPing, rateLimitPing, logDropped, trustedInterfaces}`

### Kernel Hardening (`security-kernel`)
- Kernel hardening parameters
- ASLR, stack protection
- Blacklisted uncommon protocols
- sysctl security settings
- **Options**: `sec.bestPractices.kernel.enable`

### Filesystem Security (`security-filesystem`)
- Hardened /tmp mount (noexec, nosuid, nodev)
- tmpfs configuration
- **Options**: `sec.bestPractices.filesystem.enable`

### Sudo Hardening (`security-sudo`)
- Wheel group enforcement
- Sudo logging and auditing
- Resource limits
- **Options**: `sec.bestPractices.sudo.enable`

### Fail2Ban (`security-fail2ban`)
- Intrusion prevention
- Progressive ban times
- SSH jail enabled by default
- **Options**: `sec.bestPractices.fail2ban.{enable, bantime, maxretry}`

### Network Hardening (`security-network`)
- IPv6 toggle
- TCP/IP stack hardening
- Reverse path filtering
- **Options**: `sec.bestPractices.network.{enable, disableIPv6}`

### Intrusion Detection System (`security-ids`)
- **Suricata** network IDS/IPS
- EVE JSON logging for SIEM integration
- Automated rule updates (daily)
- Monitors: HTTP, DNS, TLS, SMTP, files, anomalies
- Home network definition with customizable ranges
- **Options**: `sec.bestPractices.ids.{enable, interface, logLevel, enableEveLog, homenet}`

### Antivirus (`security-antivirus`)
- ClamAV daemon
- Fangfrisch updates
- Automated scanning
- **Options**: `sec.antivirus.enable`

### Audit & Compliance (`security-audit`)
- Auditd with comprehensive rules
- AppArmor
- File integrity monitoring
- **Options**: `security.compliance.enable`

### Security Monitoring (`security-monitoring`)
- **Comprehensive telegraf integration** for all security logs
- **Collected logs:**
  - Auditd events (`/var/log/audit/audit.log`)
  - Fail2Ban status and bans
  - Sudo commands (`/var/log/sudo.log`)
  - Suricata IDS events (EVE JSON + text logs)
  - SSH authentication (journald)
  - Firewall drops (journald)
  - ClamAV daemon (journald)
  - System security events (journald)
- **Metrics collected:**
  - Active user count
  - Fail2Ban banned IPs count
  - Suricata packets captured
  - SSH failed login attempts (5min window)
  - Firewall dropped packets (5min window)
- Local file and socket outputs
- **Options**: `sec.bestPractices.monitoring.enable`

## Monitoring Output

When `sec.bestPractices.monitoring.enable = true`, all security logs and metrics are collected:

### Output Destinations
- `/var/log/telegraf/security-metrics.json` - JSON formatted metrics
- `unix:///var/run/telegraf-security.sock` - Real-time socket

### Log Sources Collected
1. **Auditd** - System audit events (`/var/log/audit/audit.log`)
2. **Fail2Ban** - Ban events and status
3. **Sudo** - All sudo command executions (`/var/log/sudo.log`)
4. **Suricata IDS** - Network events, alerts, anomalies (`/var/log/suricata/eve.json`)
5. **SSH** - Authentication attempts (via journald)
6. **Firewall** - Dropped packets (via journald)
7. **ClamAV** - Antivirus events (via journald)
8. **Journald** - All systemd security service logs

### Metrics Calculated
- `active_users` - Current logged-in user count
- `fail2ban_banned_count` - Number of currently banned IPs
- `suricata_packets_captured` - Total packets analyzed by IDS
- `ssh_failed_login_attempts` - Failed SSH logins (last 5 minutes)
- `firewall_dropped_packets` - Packets dropped by firewall (last 5 minutes)

### View Metrics
```bash
# All security metrics (JSON)
tail -f /var/log/telegraf/security-metrics.json | jq .

# Suricata alerts only
tail -f /var/log/telegraf/security-metrics.json | jq 'select(.name=="suricata_eve" and .fields.event_type=="alert")'

# SSH failed logins
tail -f /var/log/telegraf/security-metrics.json | jq 'select(.name=="ssh_failed_login_attempts")'

# Firewall drops
tail -f /var/log/telegraf/security-metrics.json | jq 'select(.name=="firewall_dropped_packets")'

# Real-time socket
socat - UNIX-CONNECT:/var/run/telegraf-security.sock
```

## Module Exports

All modules are exported in `flake.nix` as:
- `polarbear.nixosModules.security` - All security modules
- `polarbear.nixosModules.security-*` - Individual modules
- `polarbear.nixosModules.{antivirus,compliance}` - Legacy aliases (deprecated)
