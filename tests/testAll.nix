{ self, pkgs, ... }:
pkgs.nixosTest {

  name = "testAll";
  nodes.machine = { config, pkgs, ... }: {
    imports = [
      self.nixosModules.default
    ];
    system.stateVersion = "25.05";
    # self.antivirus.enable = true;
  };
  testScript = /*python*/  ''
    machine.succeed("id charles")
  '';
}
