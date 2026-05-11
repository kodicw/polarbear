{ lib, ... }:
{
  imports = [
    ./anti_virus/default.nix
    ./compliance/default.nix
    ./fail2ban/default.nix
    ./firewall/default.nix
    ./filesystem/default.nix
    ./ids/default.nix
    ./kernel/default.nix
    ./monitoring/default.nix
    ./network/default.nix
    ./ssh/default.nix
    ./sudo/default.nix
  ];
}
