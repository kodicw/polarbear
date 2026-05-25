# Agent Instructions for `polarbear`

This Nix flake provides curated NixOS modules, development toolchains, utility packages, and a customized Neovim (nixvim) configuration.

## Architecture & Layout

- **`flake.nix`**: The single entrypoint exposing `packages`, `devShells`, `nixosModules`, and `lib` for multiple architectures (`x86_64-linux`, `aarch64-linux`, `x86_64-darwin`, `aarch64-darwin`).
- **`lib/`**: Custom Nix functions (`mkHardenedBoot`, `mkUserGroups`) documented with `nixdoc`.
- **`packages/`**: Grouped toolchains and applications. Most use `pkgs.buildEnv`; exceptions noted below.
  - `packages/nixvim/` — Custom nixvim configuration split across `default.nix`, `keymaps.nix`, `plugins.nix`, `treesitter.nix`, `lsp.nix`.
  - `packages/desktop/` — Desktop applications (uses `unfreepkgs`).
  - `packages/gaming/` — Gaming tools: steam, protontricks, bottles (uses `unfreepkgs`).
  - `packages/development/` — `dev-python` (uses `python312.withPackages`), `dev-tools`, `dev-android` (uses `unfreepkgs`).
  - `packages/tools/` — `tools-net`, `tools-ssh`, `tools-nix`, `tools-sre`, `tools-ai`, `tools-red`, `tools-sip`, `tools-cli`, `tools-media`.
- **`modules/`**: NixOS modules.
  - `modules/default.nix` — Imports `users`, `settings`, `monitoring`.
  - `modules/security/` — **Opt-in** hardening modules under `sec.bestPractices.*` namespace. NOT included in `nixosModules.default`.
  - `modules/monitoring/` — Telegraf and Prometheus node exporter modules.
  - `modules/settings/` — Nix settings (experimental features, store optimisation).
  - `modules/users/` — User definitions (`charles` with nushell, `root`).

## Flake Outputs

### Packages (per system)
| Output | Description |
|--------|-------------|
| `nixvim` | Custom Neovim via nixvim |
| `docs` | Markdown docs generated from `lib/` via nixdoc |
| `tools-net`, `tools-ssh`, `tools-nix`, `tools-sre`, `tools-ai`, `tools-red`, `tools-sip`, `tools-cli`, `tools-media` | Grouped tool environments |
| `dev-python`, `dev-tools`, `dev-android` | Development toolchains |
| `desktop-apps`, `gaming` | Unfree package groups |

### NixOS Modules
| Output | Description |
|--------|-------------|
| `nixosModules.default` | Imports `modules/` (users, settings, monitoring) |
| `nixosModules.security` | All security hardening modules |
| `nixosModules.security.{ssh,firewall,kernel,filesystem,sudo,fail2ban,network,ids,antivirus,audit}` | Individual security modules |
| `nixosModules.monitoring` | Monitoring modules (telegraf, prometheus exporter) |
| `nixosModules.users.{charles,root}` | User module presets |

### DevShells
| Output | Description |
|--------|-------------|
| `devShells.default` | Provides `nixpkgs-fmt` |

## Commands & Workflows

- **Check Flake**: `nix flake check --all-systems` (all architectures) or `nix flake check` (host only).
- **Format Code**: `nixpkgs-fmt **/*.nix` (available via `nix develop` or the default devShell).
- **Build Docs**: `nix build .#docs` → output in `./result/index.md`.
- **Enter DevShell**: `nix develop` to get `nixpkgs-fmt` in PATH.

## Git Hooks

The repository includes custom hooks in `.githooks/`:

- **pre-commit**: Auto-formats staged `.nix` files with `nixpkgs-fmt`, runs `nix flake check --accept-flake-config`, and strips trailing whitespace.
- **pre-push**: Runs `nix flake check --accept-flake-config`, builds `.#packages.x86_64-linux.docs`, and formats all `.nix` files.

Activate with: `git config core.hooksPath .githooks`

## Quirks & Conventions

- **Multiple Architectures**: `flake.nix` loops over `supportedSystems` via `nixpkgs.lib.genAttrs`. Do not hardcode `x86_64-linux` or other architectures into package derivations unless strictly host-specific.
- **Unfree Packages**: `unfreepkgs` (with `config.allowUnfree = true`) is used for `desktop-apps`, `gaming`, and `dev-android`. These are explicitly separated from free packages.
- **Python Package**: `dev-python` uses `python312.withPackages` (not `buildEnv`). When adding packages, add them to the `ps: with ps; [ ... ]` list.
- **Nixvim**: Built via `nixvim.legacyPackages.${system}.makeNixvimWithModule`. Configuration is modularized into `default.nix` (core opts/globals), `keymaps.nix`, `plugins.nix`, `treesitter.nix`, and `lsp.nix`.
- **Security Modules**: All security modules live under the `sec.bestPractices.*` option namespace and are **opt-in**. They are NOT imported by `nixosModules.default`. See `modules/security/README.md` for detailed usage.
- **Cache**: The flake configures `nix-community.cachix.org` as an extra substituter.
- **Lib Functions**: Functions in `lib/default.nix` use nixdoc-compatible doc comments (`/** ... */`). Keep docs in that format so `nix build .#docs` continues to work.
