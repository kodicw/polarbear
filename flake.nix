{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      runCheck = path: pkgs.callPackage path { inherit self; };
    in
    {
      nixosModules =
        {
          # Modules
          all = import ./modules/all.nix;
          antivirus = import ./modules/security/anti_virus;
          compliance = import ./modules/security/compliance;
          # Users
          charles = import ./modules/users/charles; # My personal user
          root = import ./modules/users/root;
        };
      checks = {
        ${system} = {
          testAll = runCheck ./tests/testAll.nix;
        };
      };
    };
}
