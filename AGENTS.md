# Agent Instructions for `polarbear`

This Nix flake provides curated NixOS modules, development tools, and utility packages.

## Architecture & Layout

- **`flake.nix`**: The single entrypoint exposing `packages`, `devShells`, `nixosModules`, and `lib` for multiple architectures (`x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`).
- **`packages/`**: Contains grouped toolchains and applications (mostly using `pkgs.buildEnv`). When adding new grouped packages, make sure they are exposed inside `flake.nix` in the `packages` output.
- **`modules/`**: Contains NixOS modules (security, monitoring, users). Notice that `nixosModules.default` imports `./modules`, but certain specialized modules (e.g., `modules/security/*`) are opt-in and are explicitly exposed as individual outputs in `flake.nix`.
- **`lib/`**: Contains custom Nix functions.

## Commands & Workflows

- **Check Flake**: Run `nix flake check --all-systems` to verify that all systems evaluate successfully. Use `nix flake check` to test just the host architecture.
- **Format Code**: Use `nixpkgs-fmt` (available via `nix develop`). Always run `nixpkgs-fmt **/*.nix` on modified files before committing.
- **Build Docs**: Library functions in `lib/default.nix` are documented using `nixdoc`. Build the markdown docs by running `nix build .#docs`. The output will be in `./result/index.md`.

## Quirks & Conventions

- **Multiple Architectures**: `flake.nix` loops over `supportedSystems` via `nixpkgs.lib.genAttrs`. Do not hardcode `x86_64-linux` or other architectures into package derivations in `flake.nix` unless it's strictly host-specific.
- **Unfree Packages**: Unfree packages are allowed by default for specific outputs (like `desktop-apps` and `gaming`) via a custom `unfreepkgs` instance in `flake.nix`.
- **Nixvim**: The repository builds a customized `nixvim` package using `nixvim.legacyPackages.${system}.makeNixvimWithModule` pulling from `packages/nixvim/`.