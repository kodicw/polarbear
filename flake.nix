{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixvim,
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      unfreepkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.${system} = {
        nixvim = nixvim.legacyPackages."${system}".makeNixvimWithModule {
          inherit pkgs;
          module = import ./packages/nixvim;
        };

        tools-net = import ./packages/tools/networking { inherit pkgs; };
        tools-ssh = import ./packages/tools/ssh { inherit pkgs; };
        tools-nix = import ./packages/tools/nix { inherit pkgs; };
        tools-sre = import ./packages/tools/sre { inherit pkgs; };
        tools-ai = import ./packages/tools/ai { inherit pkgs; };
        tools-red = import ./packages/tools/red { inherit pkgs; };
        dev-python = import ./packages/development/python { inherit pkgs; };
        dev-tools = import ./packages/development/tools { inherit pkgs; };
        dev-android = import ./packages/development/android { pkgs = unfreepkgs; };
        desktop-apps = import ./packages/desktop { inherit pkgs; };
        gaming = import ./packages/gaming { inherit pkgs; };
      };

      nixosModules = {
        # Modules
        default = import ./modules;

        # Security (opt-in, not included in default)
        security = {
          default = import ./modules/security;
          ssh = import ./modules/security/ssh;
          firewall = import ./modules/security/firewall;
          kernel = import ./modules/security/kernel;
          filesystem = import ./modules/security/filesystem;
          sudo = import ./modules/security/sudo;
          fail2ban = import ./modules/security/fail2ban;
          network = import ./modules/security/network;
          ids = import ./modules/security/ids;
          antivirus = import ./modules/security/anti_virus;
          audit = import ./modules/security/compliance;
        };
        monitoring = import ./modules/security/monitoring;

        # Users
        users = {
          charles = import ./modules/users/charles;
          root = import ./modules/users/root;
        };
      };
    };
}
