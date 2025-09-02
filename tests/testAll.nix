{ self, pkgs, ... }:
pkgs.nixosTest {

  name = "testAll";
  nodes.machine = { config, pkgs, ... }: {
    imports = [
      self.nixosModules.all
    ];
    system.stateVersion = "25.05";
    security.antivirus.enable = true;
  };
  testScript = /*python*/  ''
    machine.succeed("id charles")
  '';
}
