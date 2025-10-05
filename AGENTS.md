# Agent Guidelines for Polarbear NixOS Configuration

## Build & Test Commands
- Build all: `nix build`
- Build nixvim: `nix build .#nixvim`
- Run all tests: `nix flake check`
- Run single test: `nix build .#checks.x86_64-linux.testAll`
- Update flake: `nix flake update`

## Code Style
- **Language**: Nix expressions only
- **Indentation**: 2 spaces, no tabs (matching nixvim config)
- **Imports**: Use `lib.fileset.toList` for auto-importing default.nix files
- **Naming**: kebab-case for files (e.g., `cli-apps.nix`), camelCase for variables
- **Module pattern**: Follow `{ pkgs, lib, config, ... }:` function signature
- **Options**: Use `lib.mkEnableOption` for boolean options, namespace with `cfg = config.${namespace}`
- **Let bindings**: Define variables in `let...in` blocks before main expression
- **Lists**: Simple package lists use `with pkgs; [ pkg1 pkg2 ]` pattern
- **Testing**: Tests use `pkgs.nixosTest` with Python testScript
- **Comments**: Minimal, only for clarification. Use `# comment` style
- **Formatting**: Use standard Nix formatting, align `=` in attribute sets when grouped
