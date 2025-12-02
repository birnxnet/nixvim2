# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with
code in this repository.

## Overview

Khanelivim is a fully customized Neovim configuration built with Nix and
[Nixvim](https://github.com/nix-community/nixvim). It provides a reproducible,
declarative Neovim setup with 100+ plugins organized in a modular architecture.

## Commands

- `nix flake update` - Update Nix flake
- `nix flake check` - Check Nix flake with `nix flake check`
- `nix develop` - Enter development shell
- `nix run` - Activate the configuration
- `nix build` - Build the configuration
- `nix fmt` - Format all Nix files
- `new-plugin <plugin-name> <template-type>` - Generate new plugin templates
  (available in dev shell, template-type: custom, custom-lazy, nixvim)

### Just Commands

The project uses `just` as a task runner:

- `just` - List available commands
- `just update` - Update nix flake
- `just lint` - Lint nix files with `nix fmt`
- `just check` - Check nix flake
- `just dev` - Enter dev shell
- `just run` - Activate the configuration

## Codebase Architecture

```
khanelivim/
├── flake.nix                 # Main flake entry point
├── flake.lock                # Locked dependencies
├── flake/                    # Flake configuration modules
│   ├── default.nix           # Flake module organization
│   ├── nixvim.nix            # Nixvim configuration builder (profiles)
│   ├── overlays.nix          # Overlay loader
│   ├── pkgs-by-name.nix      # Custom package integration
│   ├── apps/                 # Utility apps (profile, update, etc.)
│   │   ├── profile.nix       # Performance profiling tool
│   │   ├── update.nix        # Flake update utility
│   │   ├── grammar-sizes.nix # Treesitter grammar analysis
│   │   └── pack-dir.nix      # Pack directory utilities
│   └── dev/                  # Development partition
│       ├── devshell.nix      # Development shell config
│       ├── git-hooks.nix     # Pre-commit hooks
│       ├── treefmt.nix       # Formatter configuration
│       └── new-plugin.py     # Plugin template generator
├── modules/
│   ├── khanelivim/           # High-level options system
│   │   ├── default.nix       # Options module entry point
│   │   └── options/          # Option definitions (16 files)
│   │       ├── ai.nix        # AI provider options
│   │       ├── completion.nix
│   │       ├── dashboard.nix
│   │       ├── debugging.nix
│   │       ├── documentation.nix
│   │       ├── editor.nix
│   │       ├── git.nix
│   │       ├── loading.nix
│   │       ├── lsp.nix
│   │       ├── performance.nix
│   │       ├── picker.nix
│   │       ├── profiles.nix  # minimal/basic/standard/full presets
│   │       ├── tasks.nix
│   │       ├── text.nix
│   │       ├── ui.nix
│   │       └── utilities.nix
│   └── nixvim/               # Nixvim configuration
│       ├── default.nix       # Auto-imports all plugins
│       ├── options.nix       # Vim options
│       ├── keymappings.nix   # Global keymaps
│       ├── autocommands.nix  # Autocommands
│       ├── lsp.nix           # LSP configuration
│       ├── diagnostics.nix   # Diagnostic settings
│       ├── performance.nix   # Performance optimizations
│       ├── dependencies.nix  # Plugin dependencies
│       ├── lua.nix           # Lua configuration
│       ├── ft.nix            # Filetype configuration
│       ├── usercommands.nix  # User commands
│       ├── lsp/              # LSP server configs (10 files)
│       └── plugins/          # Plugin configurations (119 directories)
├── overlays/                 # Nix package overlays
│   ├── input-packages.nix    # Package overrides from nixpkgs-master
│   └── neovim-nightly.nix    # Neovim nightly overlay
├── packages/                 # Custom package definitions
│   ├── git-conflict/
│   ├── neotest-catch2/
│   ├── neovim-tasks/
│   ├── tree-sitter-kulala-http/
│   └── tree-sitter-norg-meta/
└── shells/                   # Development shell configuration
    └── default.nix
```

## Options System (khanelivim)

The `khanelivim` options module provides a high-level declarative interface for
configuring the entire Neovim setup. Options map to plugin configurations.

### Key Options Namespaces

| Namespace                  | Purpose                                       |
| -------------------------- | --------------------------------------------- |
| `khanelivim.ai`            | AI provider (copilot, avante, codecompanion)  |
| `khanelivim.completion`    | Completion engine (blink, cmp)                |
| `khanelivim.dashboard`     | Dashboard tool (snacks, mini-starter)         |
| `khanelivim.debugging`     | DAP adapters and UI                           |
| `khanelivim.editor`        | File manager, search, motion, HTTP client     |
| `khanelivim.git`           | Git integrations and diff viewer              |
| `khanelivim.lsp`           | LSP server selection                          |
| `khanelivim.picker`        | Picker tool (telescope, fzf-lua, snacks)      |
| `khanelivim.text`          | Comments, markdown, operators, patterns       |
| `khanelivim.ui`            | Statusline, bufferline, notifications, etc.   |
| `khanelivim.utilities`     | Session, clipboard, screenshots               |
| `khanelivim.profile`       | Profile preset (minimal/basic/standard/full)  |

### Configuration Profiles

Defined in `modules/khanelivim/options/profiles.nix`:

- **minimal**: Just treesitter, LSP, completion - no UI enhancements
- **basic**: Core editing + statusline + gitsigns + snacks picker
- **standard**: Full features, deduplicated (one AI tool, one file manager)
- **full**: All features enabled including duplicates (default)

## Plugin Configuration Patterns

Plugins are in `modules/nixvim/plugins/`. The `default.nix` auto-imports all
plugin directories.

### Pattern 1: Simple Plugin

```nix
# plugins/copilot-lsp/default.nix
{
  plugins.copilot-lsp = {
    enable = true;
    lazyLoad.settings.event = [ "InsertEnter" ];
    settings = { /* plugin config */ };
  };
}
```

### Pattern 2: Plugin with Conditional Enable

```nix
# plugins/gitsigns/default.nix
{ config, lib, ... }:
{
  plugins.gitsigns = {
    enable = lib.elem "gitsigns" config.khanelivim.git.integrations;
    lazyLoad.settings.event = "DeferredUIEnter";
    settings = { /* config */ };
  };
}
```

### Pattern 3: Plugin with Keymaps and Which-Key

```nix
{ config, lib, ... }:
{
  plugins.myplugin = {
    enable = true;
    settings = { /* config */ };
  };

  # Which-key group registration
  plugins.which-key.settings.spec = lib.optionals config.plugins.myplugin.enable [
    {
      __unkeyed-1 = "<leader>x";
      group = "My Plugin";
      icon = " ";
    }
  ];

  # Conditional keymaps
  keymaps = lib.mkIf config.plugins.myplugin.enable [
    {
      mode = "n";
      key = "<leader>xa";
      action = "<cmd>MyPluginAction<CR>";
      options.desc = "My Action";
    }
  ];
}
```

### Pattern 4: Modular Plugin with Sub-files

```nix
# plugins/snacks/default.nix
{ config, lib, ... }:
{
  imports = [
    ./bigfile.nix
    ./dashboard.nix
    ./notifier.nix
    ./picker.nix
    # ... more modules
  ];

  plugins.snacks = {
    enable = true;
    settings = {
      indent.enabled = config.khanelivim.ui.indentGuides == "snacks";
      # ...
    };
  };
}
```

### Pattern 5: Lua Code Blocks

Use `__raw` for inline Lua:

```nix
{
  action.__raw = ''
    function()
      require('gitsigns').stage_hunk()
      vim.notify('Hunk staged', vim.log.levels.INFO)
    end
  '';
}
```

### Lazy Loading Events

Common lazy loading triggers:

- `"InsertEnter"` - When entering insert mode
- `"DeferredUIEnter"` - After UI loads (lz.n custom event)
- `"BufReadPost"` / `"BufNewFile"` - When opening files
- `"VeryLazy"` - Deferred after startup
- `cmd = [ "PluginCommand" ]` - On command invocation
- `keys = [ "<leader>key" ]` - On keymap trigger

## LSP Configuration

LSP servers are configured in `modules/nixvim/lsp/` and main `lsp.nix`.

### Adding a New LSP Server

1. Create `modules/nixvim/lsp/myserver.nix`:

```nix
{ config, lib, ... }:
{
  plugins.lsp.servers.myserver = {
    enable = lib.elem "myserver" config.khanelivim.lsp.servers;
    settings = { /* server settings */ };
  };
}
```

2. Add to `khanelivim.lsp.servers` option in `modules/khanelivim/options/lsp.nix`

### Existing LSP Servers

bashls, ccls, clangd, cssls, dockerls, gopls, html, jdtls, jsonls, lua-ls,
marksman, harper-ls, nil-ls, nixd, pyright, rust-analyzer, sqls, taplo,
typescript-tools, yamlls, helm-ls, typos-lsp, roslyn, rzls

## Code Style Guidelines

- Nix files: Format with nixfmt (RFC style)
- Use statix for Nix linting and deadnix to detect unused code
- Follow modular architecture in `modules/` for Neovim configuration
- Individual plugins should be configured in separate directories under
  `plugins/`
- Luacheck is used for Lua files
- For TypeScript/JavaScript use biome for formatting
- Follow existing naming conventions when adding new modules or plugins

## Development Workflow

1. **Enter dev shell**: `nix develop`
2. **Make changes** in appropriate module files
3. **Lint and fix**:
   - `deadnix -e` - Remove unused code
   - `statix fix .` - Fix linting issues
   - `nix fmt` - Format Nix files
4. **Verify**: `nix flake check`
5. **Test**: `nix run` to activate the configuration

### Adding a New Plugin

1. Enter dev shell: `nix develop`
2. Generate template: `new-plugin <name> <template-type>`
   - `nixvim` - Standard plugins with native Nixvim options
   - `custom` - Plugins requiring custom Lua configuration
   - `custom-lazy` - Plugins with lazy loading and custom config
3. Configure in `modules/nixvim/plugins/<name>/default.nix`
4. Add khanelivim option if needed in `modules/khanelivim/options/`
5. Test with `nix run`

## Git Commit Conventions

This project uses a **scope-based commit format**, NOT conventional commits.

### Format

```
scope: description
```

- **Scope**: The module, component, or file being changed
- **Description**: Lowercase verb phrase describing the change
- **NO type prefix** (no `feat:`, `fix:`, `perf:`, etc.)

### Examples

**Plugin changes:**

```
copilot-lsp: add lazy loading on InsertEnter
fff: disable debug mode and add lazy loading to prevent crashes
no-neck-pain: add module
lualine: use package.loaded for sidekick status
```

**Module/options changes:**

```
nixvim/options: refactor and cleanup
options/ui: add zenMode option
options/profiles: init module
```

**Build/infrastructure:**

```
flake.lock: update vimplugins
flake.lock: update
.github: Bump DeterminateSystems/update-flake-lock from 27 to 28
overlays/input-packages: skip checks for fzf,grug,neotest
```

**Documentation/performance:**

```
docs: add crash debugging and troubleshooting guide
docs: update profiling docs for per-event baselines
performance: add disabled plugins
```

**Apps/scripts:**

```
apps/profile: more runs on baseline
apps/profile: support profile baselines and compares
apps/profile: use event-specific baselines
```

### Common Scopes

- Plugin name: `copilot-lsp`, `fff`, `telescope`, `lualine`, etc.
- Module path: `nixvim/options`, `options/ui`, `overlays/input-packages`
- Special scopes: `docs`, `performance`, `flake.lock`, `.github`

### Action Verbs

- `add` - New feature, module, or functionality
- `update` - Update existing code or dependencies
- `remove` - Delete code or features
- `fix` - Bug fixes
- `refactor` - Code restructuring without behavior change
- `disable` - Turn off a feature
- `enable` - Turn on a feature
- `init` - Initialize new module or component

### Multi-line Commits

For complex changes, use a blank line after the subject, then add details:

```
scope: brief description

- Detail about change 1
- Detail about change 2
- Rationale or context
```

## Performance Profiling

**IMPORTANT**: When making changes to plugin configurations, lazy loading, or
adding new plugins, always measure the performance impact using these tools.

### Quick Commands

```bash
# Interactive mode (recommended - accurate timing, runs in terminal)
nix run .#profile -- -i --iterations 1

# Save baseline before making changes (per-event baselines)
nix run .#profile -- -i --iterations 1 --baseline --event ui
nix run .#profile -- -i --iterations 1 --baseline --event deferred

# Compare against baseline after changes (uses matching event baseline)
nix run .#profile -- -i --iterations 1 --compare --event ui
nix run .#profile -- -i --iterations 1 --compare --event deferred

# Profile different events
nix run .#profile -- -i --event ui        # UIEnter only (~230ms typical)
nix run .#profile -- -i --event deferred  # DeferredUIEnter (~650ms typical)
```

**Note**: Baselines are stored per event type. Use `--event ui` for initial
render timing and `--event deferred` for total startup including lazy-loaded
plugins.

### Profile Output Interpretation

The profiler shows time spent per plugin:

| Plugin     | Typical   | Notes                      |
| ---------- | --------- | -------------------------- |
| `core`     | 300-500ms | autocmds, vim internals    |
| `lz.n`     | 400-500ms | lazy loading orchestration |
| `snacks`   | 300-400ms | dashboard, utilities       |
| `gitsigns` | 200-400ms | git integration            |
| `lualine`  | 50-70ms   | statusline                 |

**Performance thresholds**:

- New plugin adding >50ms: Consider lazy loading
- Regression >5% on compare: Investigate or revert
- Total deferred >800ms: Review lazy load triggers

### When to Profile

**Always profile when**:

- Adding a new plugin
- Changing lazy loading configuration (lz.n triggers, events)
- Modifying plugin setup options
- Adding autocmds or keymaps that trigger plugin loads

**Workflow**:

1. Save baselines before making changes:
   - `nix run .#profile -- -i --iterations 1 --baseline --event ui`
   - `nix run .#profile -- -i --iterations 1 --baseline --event deferred`
2. Make changes
3. Compare against baselines:
   - `nix run .#profile -- -i --iterations 1 --compare --event ui`
   - `nix run .#profile -- -i --iterations 1 --compare --event deferred`
4. If regression >5%, optimize or reconsider the change

### Manual Profiling

```bash
# Quick startup profile (exports to ~/nvim-profile-*.md)
PROF=1 nvim -c ':ProfilerExport!' -c 'qa!'

# Profile with DeferredUIEnter (lz.n lazy loads)
PROF=1 PROF_EVENT=deferred nvim

# Auto-export JSON for automation
PROF=1 PROF_OUTPUT=/tmp/profile.json PROF_AUTO_QUIT=1 nvim
```

### Interactive Profiling (runtime)

- `<leader>up` - Toggle profiler on/off
- `<leader>uP` - Toggle profiler highlights (inline metrics)
- `<leader>ps` - Open profiler scratch buffer (adjust options)
- `:ProfilerExport` - Export to scratch buffer
- `:ProfilerExport!` - Export to auto-named file
- `:ProfilerExportJson!` - Export as JSON

### Profile Data Location

- Profiles stored in: `~/.cache/khanelivim/profiles/`
- Baselines (per event type):
  - `~/.cache/khanelivim/profiles/baseline-ui.json`
  - `~/.cache/khanelivim/profiles/baseline-deferred.json`
  - `~/.cache/khanelivim/profiles/baseline-lazy.json`

### Environment Variables

| Variable         | Description                          |
| ---------------- | ------------------------------------ |
| `PROF=1`         | Enable startup profiling             |
| `PROF_EVENT`     | Stop event: `ui`, `deferred`, `lazy` |
| `PROF_OUTPUT`    | Auto-export path                     |
| `PROF_FORMAT`    | Export format: `md`, `json`, `both`  |
| `PROF_AUTO_QUIT` | Exit after export (for automation)   |

## Overlays

Overlays in `overlays/` modify or add packages:

- **input-packages.nix**: Overrides packages from nixpkgs-master (claude-code,
  github-copilot-cli, opencode), disables checks for fzf-lua, grug-far-nvim,
  neotest, and overrides snacks-nvim with custom source
- **neovim-nightly.nix**: Neovim nightly overlay

Overlays are auto-loaded via `flake/overlays.nix`.

## Custom Packages

Packages in `packages/` are custom derivations:

- **git-conflict** - Git conflict resolution plugin
- **neotest-catch2** - Neotest adapter for Catch2 testing
- **neovim-tasks** - Neovim task integration
- **tree-sitter-kulala-http** - Tree-sitter grammar for Kulala HTTP
- **tree-sitter-norg-meta** - Tree-sitter grammar for Norg meta

Add new packages by creating `packages/<name>/package.nix`.

## GitHub Workflows

Located in `.github/workflows/`:

- **build.yml** - Build configuration packages
- **check.yml** - Nix flake check validation
- **deadnix.yml** - Check for unused Nix code
- **fmt.yml** - Formatting validation
- **label.yml** - PR labeling automation
- **lint.yml** - Linting checks
- **update-flakes.yml** - Automated flake updates

## Crash Debugging & Troubleshooting

When Neovim crashes (segfaults, freezes, or unexpected behavior), follow this
systematic debugging approach.

### Step 1: Check for Crash Logs

Neovim and system logs can provide immediate insight into crashes:

```bash
# Check for core dumps (most useful for segfaults)
coredumpctl list nvim

# View most recent crash details
coredumpctl info $(coredumpctl list nvim | tail -1 | awk '{print $5}')

# Get stack trace from most recent crash
coredumpctl debug $(coredumpctl list nvim | tail -1 | awk '{print $5}') \
  --debugger-arguments="-batch -ex 'bt' -ex 'quit'"

# Check Neovim state logs
ls -lth ~/.local/state/nvim/*.log | head -5

# Check kernel logs for segfaults
dmesg | grep -i segfault | grep nvim | tail -10

# Check systemd journal
journalctl --user | grep -i nvim | tail -20
```

### Step 2: Analyze Stack Traces

When examining a coredump stack trace, look for these key indicators:

**Main thread crash patterns:**

```
#0  multiqueue_put_event    <- Event queue corruption
#1  emit_termrequest         <- Terminal I/O race condition
#2  state_handle_k_event     <- Keyboard event handling
#3  normal_execute           <- Normal mode execution
```

**Common crash locations and meanings:**

| Function                | Likely Cause                                    |
| ----------------------- | ----------------------------------------------- |
| `multiqueue_put_event`  | Race condition between threads/event loops      |
| `emit_termrequest`      | Terminal request/response timing issue          |
| `lua_*` functions       | Lua plugin crash, check loaded modules          |
| `tree_sitter_*`         | Treesitter parser issue, check language parsers |
| Background thread crash | Plugin with threading (fff, telescope, etc.)    |

**Background threads in stack trace:**

Multiple worker threads (rayon, inotify, crossbeam) indicate:

- Plugin with heavy parallelism (fff, telescope, etc.)
- File watching/indexing operations
- Potential race conditions with main thread

### Step 3: Identify the Culprit Plugin

**Check loaded modules in coredump:**

```bash
# Look for plugin-specific shared libraries in crash info
coredumpctl info <pid> | grep -i "Module.*\.so"
```

Common indicators:

- `libfff_nvim.so` - fff file finder
- `libtree-sitter.so` - Treesitter parsers
- Custom `.so` files - Binary plugins

**Correlate with your configuration:**

1. Note which plugins were recently added/modified
2. Check if plugins have `debug` or `verbose` modes enabled
3. Identify plugins that are NOT lazy-loaded (immediate startup)
4. Look for plugins with background workers or file watchers

### Step 4: Common Race Conditions

**Dashboard + File Finder Crash:**

- **Symptom:** Crash when quickly opening file from dashboard
- **Cause:** Dashboard terminal sections + eager-loaded file finder
- **Solution:** Lazy-load file finder, disable debug modes

**LSP + Completion Crash:**

- **Symptom:** Crash when typing quickly or on completion
- **Cause:** Multiple LSP clients + completion plugin race
- **Solution:** Ensure single LSP client per filetype, lazy-load completion

**Treesitter + Fold Crash:**

- **Symptom:** Crash when opening/editing large files
- **Cause:** Treesitter parsing + fold calculation simultaneously
- **Solution:** Disable folds for large files, lazy-load fold plugins

### Step 5: Debugging Workflow

**Reproduce the crash:**

```bash
# Run with verbose logging
nvim --startuptime startup.log -V9startup_verbose.log

# Run with minimal config to isolate issue
nvim -u NONE  # Completely clean
nvim -u minimal.lua  # Your minimal config
```

**Binary search for culprit:**

1. Disable half your plugins
2. Test if crash still occurs
3. Re-enable/disable half of remaining suspects
4. Repeat until single plugin identified

**Quick checks:**

```bash
# Check for plugins with debug modes enabled
rg "debug.*enabled.*true" modules/nixvim/plugins/

# Check for plugins without lazy loading
rg "plugins\.\w+\s*=\s*{" modules/nixvim/plugins/ | \
  xargs -I {} sh -c 'grep -L "lazyLoad" {}'

# Find plugins with heavy background operations
rg -i "worker|thread|async|background" modules/nixvim/plugins/
```

### Step 6: Fixing Race Conditions

**General solutions:**

1. **Lazy load aggressive plugins:**
   ```nix
   lazyLoad.settings = {
     cmd = [ "PluginCommand" ];
     keys = [ "<leader>key" ];
   };
   ```

2. **Disable debug modes:**
   ```nix
   debug.enabled = false;  # Reduces thread overhead
   ```

3. **Sequence plugin loading:**
   - Dashboard should load first (before file operations)
   - File finders should lazy load on keymap
   - LSP should wait for FileType events

4. **Reduce parallelism:**
   - Limit worker threads in plugin configs
   - Disable background file watchers if unnecessary
   - Use synchronous operations for critical paths

### Step 7: Document Your Fix

Always add comments explaining race condition fixes:

```nix
# Debug mode disabled to prevent race condition crashes when quickly opening
# files from dashboard. Debug mode spawns ~20 background threads that conflict
# with terminal request/response system causing segfaults in multiqueue_put_event.
debug.enabled = false;
```

This helps future you (and others) understand why seemingly useful features are
disabled.

## Key Plugins by Category

### AI & Code Intelligence

avante, blink, copilot, copilot-lsp, claude-code, claudecode, codecompanion

### Navigation & Search

telescope (+ extensions), fzf-lua, snacks picker, flash, hop, harpoon

### File Management

yazi, neo-tree, fff

### Git Integration

gitsigns, diffview, git-conflict, git-worktree, gitignore

### LSP & Completion

lspconfig, blink, navic, glance, lightbulb, trouble

### Debugging & Testing

dap, dap-ui, dap-virtual-text, neotest

### UI/UX

catppuccin, bufferline, lualine, which-key, noice, snacks, indent-blankline

### Treesitter

treesitter, treesitter-context, treesitter-refactor

See `modules/nixvim/plugins/` for complete list (119 plugin directories).
