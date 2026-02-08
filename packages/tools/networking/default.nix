{ pkgs, ... }:
pkgs.buildEnv {
  name = "networking-tools";
  paths = with pkgs; [
    aircrack-ng
    bettercap
    iperf3
    mitmproxy
    netcat
    netscanner
    ngrep
    nmap
    rustscan
    tcpdump
    whois
    # whosthere
    wireshark
  ];
}
