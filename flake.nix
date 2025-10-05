{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, nixvim }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      runCheck = path: pkgs.callPackage path { inherit self; };
      inputs' = { inherit self nixpkgs nixvim; };
    in
    {
      packages.${system} = {
        nixvim = nixvim.legacyPackages."${system}".makeNixvimWithModule { inherit pkgs; module = import ./modules/packages/nixvim/config.nix; };
      };

      nixosModules =
        {
          # Modules
          default = import ./modules/all.nix;
          
          # Security (opt-in, not included in default)
          security = import ./modules/security;
          security-ssh = import ./modules/security/ssh;
          security-firewall = import ./modules/security/firewall;
          security-kernel = import ./modules/security/kernel;
          security-filesystem = import ./modules/security/filesystem;
          security-sudo = import ./modules/security/sudo;
          security-fail2ban = import ./modules/security/fail2ban;
          security-network = import ./modules/security/network;
          security-ids = import ./modules/security/ids;
          security-antivirus = import ./modules/security/anti_virus;
          security-audit = import ./modules/security/compliance;
          security-monitoring = import ./modules/security/monitoring;
          
          # Legacy aliases (deprecated)
          antivirus = import ./modules/security/anti_virus;
          compliance = import ./modules/security/compliance;
          
          # Users
          charles = import ./modules/users/charles;
          root = import ./modules/users/root;
        };
      checks = {
        ${system} = {
          testAll = runCheck ./tests/testAll.nix;
        };
      };
    };
}
