{ pkgs, self, ... }:
let
  groups = import ./groups.nix;
  authorized_keys = import ./authorized_keys.nix;
  username = "charles";
in
{
  users = {
    users = {
      ${username} = {
        isNormalUser = true;
        shell = pkgs.nushell;
        initialHashedPassword = "$y$j9T$gSxRpeHmBy9Qt8Iz0gkEE0$6RYzT2krsz8HiAk.X.q3AVkMwpOL85FkayNFt.6saC4";
        extraGroups = groups;
        openssh.authorizedKeys.keys = authorized_keys;
        # packages = [ self.packages.x86-64_linux.nixvim ];
      };
    };
  };
}

