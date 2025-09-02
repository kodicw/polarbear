{ lib, ... }: {
  imports = lib.fileset.toList (
    # All default.nix files in ./.
    lib.fileset.fileFilter (file: file.name == "default.nix") ./.
  );
}
