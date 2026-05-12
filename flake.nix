{
  description = "NixOS flake with modules and packages for desktop, development, and security";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2hCFMx2BvUHp70UH4mR4ZdxR1t5VoCqQMo=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
    nixdoc = {
      url = "github:nix-community/nixdoc";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixvim
    , nixdoc
    ,
    }@inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      lib = import ./lib;

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
          unfreepkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in
        {
          nixvim = nixvim.legacyPackages."${system}".makeNixvimWithModule {
            inherit pkgs;
            module = import ./packages/nixvim;
          };

          docs = pkgs.runCommand "polarbear-docs"
            {
              preferLocalBuild = true;
            } ''
            mkdir -p $out
            ${nixdoc.packages.${system}.default}/bin/nixdoc \
              --file ${./lib}/default.nix \
              --category "" \
              --description "Polarbear library functions" \
              > "$out/index.md"
          '';

          tools-net = import ./packages/tools/networking { inherit pkgs; };
          tools-ssh = import ./packages/tools/ssh { inherit pkgs; };
          tools-nix = import ./packages/tools/nix { inherit pkgs; };
          tools-sre = import ./packages/tools/sre { inherit pkgs; };
          tools-ai = import ./packages/tools/ai { inherit pkgs; };
          tools-red = import ./packages/tools/red { inherit pkgs; };
          dev-python = import ./packages/development/python { inherit pkgs; };
          dev-tools = import ./packages/development/tools { inherit pkgs; };
          dev-android = import ./packages/development/android { pkgs = unfreepkgs; };
          desktop-apps = import ./packages/desktop { pkgs = unfreepkgs; };
          gaming = import ./packages/gaming { pkgs = unfreepkgs; };
        }
      );

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nixpkgs-fmt
            ];
          };
        }
      );

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
        monitoring = {
          default = import ./modules/monitoring;
          prometheus = {
            exporter = import ./modules/monitoring/prometheus/exporter;
          };
        };

        # Users
        users = {
          charles = import ./modules/users/charles;
          root = import ./modules/users/root;
        };
      };
    };
}
