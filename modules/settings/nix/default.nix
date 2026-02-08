{ lib, ... }:
{
  nix = lib.mkDefault {
    settings = {
      experimental-features = "nix-commands flakes";
      auto-optimise-store = true;
    };
  };
}
