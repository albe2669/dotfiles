# Architecture Review — Deepening Candidates

## 1. Auto-generate the `combined` registration shim [Strong]

**Files:** ~45 HM-only pass-throughs + ~10 OS-only + ~7 dual (modules/features/*.nix, lib/auto-import.nix, modules/default.nix)

**Problem:** The `combined` module is shallow in ~55 features. Interface equals implementation: one line re-exporting a single HM (or nixos/darwin) module. Zero behaviour added. Every new feature must copy-paste it.

**Solution:** Teach `lib/auto-import.nix` to synthesize the `combined` module from the classes the feature actually defines:
- HM-only → hm re-export
- nixos+HM → both
- darwin+HM → both

Delete every hand-written `combined` block that matches the pattern.

**Wins:**
- Locality: registration logic concentrates in one module
- Leverage: one auto-import, N features
- Delete ~55 shallow pass-through blocks
- Fewer files to touch when adding a feature

---

## 2. Collapse duplicated `nixos` / `darwin` module bodies [Strong]

**Files:** system-packages.nix, tailscale.nix, nix-settings.nix, stylix/default.nix, shell.nix, docker.nix

**Problem:** Six features define `nixos` and `darwin` modules with near-identical bodies. `system-packages` and `tailscale` are literally identical. Fixing a config value means editing two places. The bug lives in the divergence.

**Solution:** Extract a shared `common` body. Let each platform module import it and override only what differs. Two adapters (nixos, darwin) justify the seam — this is a real one.

**Wins:**
- Locality: shared config lives in one place
- Leverage: one body, two platform adapters
- Divergence bugs become visible at the override, not across files
- Smaller files, less copy-paste

---

## 3. Extract inline config strings to out-of-store sources [Worth exploring — CAVEAT]

**Files (safe to migrate — pure string literals, no Nix type safety to lose):**
- jetbrains/default.nix — 200-line .ideavimrc vimscript string concatenation
- claude.nix — bash notifyScript, fish shellInit with worktree helpers
- php.nix — PHP ini config as string literal
- dory.nix — inline postinstall shell script

**Files (MUST stay as Nix — have type safety and build-time API validation):**
- walker.nix — `programs.walker.config = { ... }` Nix attrs, type-checked by HM module option
- aerospace.nix — `programs.aerospace.settings = { ... }` Nix attrs, type-checked by HM module option
- ccstatusline.nix — `pkgs.formats.json {}` → `generate` (type-safe)
- ccusage.nix — `pkgs.formats.json {}` → `generate` (type-safe)
- cliamp.nix — `pkgs.formats.toml {}` → `generate` (type-safe)
- satty.nix — `pkgs.formats.toml {}` → `generate` (type-safe)
- wakatime.nix — `pkgs.formats.ini {}` → `generate` (type-safe)
- herdr/default.nix — `pkgs.formats.toml {}` → `generate` (type-safe)
- omp/theme.nix — `builtins.toJSON { ... }` (type-safe)
- hyprland/default.nix — `lib.generators.toLua` (type-safe)

**Problem:** Four features embed config as Nix string literals (vimscript, bash, fish, PHP). These are impossible to lint, syntax-highlight, or edit live. The repo already has the `mkOutOfStoreSymlink` pattern for lazygit, nvim, and others — this is a consistency gap.

**WARNING — do NOT migrate the type-safe group to plain files.** Those configs are Nix-evaluated structures (`formats.*.generate`, `builtins.toJSON`, HM module options). They get:
- Type safety: Nix validates the structure at build time
- Compile errors: API changes surface as build failures, not runtime errors
- Interpolation: secrets, theme colors, and variables are injected safely

Moving them to plain text files would lose compile-time validation and turn build errors into runtime failures.

**Solution:** Migrate only the pure-string-literal group to out-of-store symlinked files, matching the established `mkOutOfStoreSymlink` pattern. The Nix module shrinks to a three-line `xdg.configFile` call. Leave the type-safe group as Nix.

**Wins:**
- Locality: config lives in its native format next to the module
- Leverage: one established pattern, four more features use it
- Live editing without rebuild (for the string-literal group only)
- Syntax highlighting / linting in native files
- Type safety preserved for the Nix-evaluated configs

---

## 4. Centralize the worktree-creation scripts [Strong]

**Files:** claude.nix (claw, clawe, oclaw, oclawe + helpers), omp/default.nix (ompw, ompwe), herdr/default.nix (herdr-worktree-create)

**Problem:** Three modules each embed near-identical worktree-creation logic: create branch, `git worktree add`, copy dotfiles, launch tool. The copy-file lists diverge — herdr copies `.codegraph`, the others don't. A new tool means copy-pasting ~30 lines of fish again.

**Solution:** One `worktree` module exposing `mkWorktreeTool { name, tool, copyFiles }`. Each AI-tool module calls it with its name and binary. The copy-file list becomes a single parameter.

**Wins:**
- Locality: worktree logic lives in one module
- Leverage: one function, N tool wrappers
- Copy-file list divergence becomes a visible parameter
- Adding a new AI tool is one function call, not 30 lines

---

## 5. Extract `isDarwin` and `mkOutOfStoreSymlink` helpers into `lib` [Strong]

**Files:** isDarwin duplicated 9x (1password, docker, dory, nix-settings, shell, state, system-packages, tailscale, sops, stylix). mkOutOfStoreSymlink duplicated 12x (dunst, hyprland, kittykat, lazydocker, lazygit, nvim, sioyek, wallpapers, wtf, zathura, omp, opencode). Target: lib/

**Problem:** Two expressions are copy-pasted across 21 files. `isDarwin` is a regex match repeated 9 times. The `mkOutOfStoreSymlink` + `dotfilesLocation` + path-concat pattern repeats 12 times. A change to the dotfiles path or darwin detection logic touches 21 files.

**Solution:** Add `lib.isDarwin` and `lib.mkDotfilesSymlink` to `lib/`. Replace the 21 inline copies with calls.

**Wins:**
- Locality: platform detection and symlink logic concentrate in lib
- Leverage: 2 functions, 21 call sites
- Dotfiles path change touches one function, not 12 files
- Less visual noise in feature modules

---

## 6. Consolidate scattered `fish.shellInit` fragments [Worth exploring]

**Files:** claude.nix, omp/default.nix, work.nix, langs.nix, wtf/default.nix. Canonical seam: lib/shell-options.nix (`shell.initExtra`)

**Problem:** Five modules inject fish init code by writing `programs.fish.shellInit` directly. The repo already has a `shell.initExtra` option in `lib/shell-options.nix` — the intended seam — but nobody uses it. Ordering between the five fragments is undefined. Adding fish init means competing for the same option.

**Solution:** Migrate the five `programs.fish.shellInit` writers to `config.shell.initExtra`. The shell module already assembles `initExtra` into fish — the seam exists, it is just unused.

**Wins:**
- Locality: fish init assembles in one module
- Leverage: existing option, zero new code
- Ordering becomes explicit, not Nix-eval-order
- New modules use the seam instead of reaching past it

---

## 7. Deepen the AI-tool module to absorb shared wiring [Worth exploring]

**Files:** omp/default.nix, claude.nix. Shared: ai-shared/context.md, ai-shared/models.nix, ai-shared/bundles/default.nix, lib/skills-bundle.nix

**Problem:** omp and claude each independently wire the same four things: skills bundle, context.md, models data, and a notify script. The skills-bundle import path, the context.md path, and the bundle assembly are duplicated. Adding a third AI tool means copying all four wiring blocks. The `ai-shared` directory holds the data but not the wiring.

**Solution:** A `mkAiTool` function in `ai-shared` that absorbs the shared wiring — skills bundle, context, models, notify. Each tool calls it with its package, config dir, and tool-specific overrides. Two adapters (omp, claude) justify the seam; a third tool (opencode, partially overlapping) confirms it.

**Wins:**
- Locality: shared AI wiring concentrates in one module
- Leverage: one interface, N AI tools
- Adding a tool is one call, not four wiring blocks
- Skills/context/models divergence becomes visible at the call site

---

## 8. Parameterize hardcoded host-specific values [Speculative]

**Files:** network.nix (DNS 1.1.1.1/1.0.0.1), battery.nix (TLP thresholds), kitty.nix (26 key remaps), git-widget.nix (corticph/* repos), work.nix (GOPRIVATE), nixgl.nix ("nvidia" wrapper), satty.nix (screenshot path). Existing pattern: variables.nix, theme.nix define `opts.*` options.

**Problem:** A dozen features hardcode values that are host-specific: DNS servers, private-repo globs, screenshot paths, GPU wrapper names. The repo already has the `opts.*` option pattern for this — but these features don't use it. Changing DNS means editing the module, not the host config.

**Solution:** Promote the hardcoded values to `opts.*` options with sensible defaults, matching the existing `variables.nix` / `theme.nix` pattern. Hosts override at the seam; modules read from `config.opts`.

**Wins:**
- Locality: host-specific values live in host configs
- Leverage: existing `opts.*` pattern, zero new concepts
- Module implementations become host-agnostic
- Value changes don't require module edits

**Caveat:** Speculative because these are single-user dotfiles — the values rarely change across hosts. Worth doing if a second user or a work/personal split emerges.

---

## Recommended order

1. **#1** (auto-generate `combined`) — largest deletion, unblocks #2 and #7
2. **#5** (lib helpers) — same `lib/` directory, natural second step
3. **#4** (worktree consolidation) — highest-leverage functional change, independent
4. **#2** (collapse nixos/darwin dupes) — follows from #1
5. **#6** (fish shellInit) — quick win, existing seam
6. **#3** (inline configs, string-literal group only) — preserve type-safe Nix configs
7. **#7** (AI-tool module) — follows from #1
8. **#8** (parameterize host values) — lowest frequency, do if needs change
