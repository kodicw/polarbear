{ lib, ... }:
{
  imports = [
    ./hipaa.nix
    ./soc2.nix
  ];

  # Note: The auditd and apparmor logic previously in this file 
  # is now being integrated into the specific compliance/stig modules 
  # or can be enabled via sec.bestPractices.
}
