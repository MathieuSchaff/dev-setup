# AstroNvim v6 Migration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate `~/.config/nvim` from AstroNvim v5 to v6 using an isolated environment, swapping in once validated.

**Architecture:** Clone the AstroNvim v6 template into `~/.config/astronvim_v6`, copy existing user configs, apply breaking-change patches file by file, validate with `NVIM_APPNAME=astronvim_v6 nvim`, then swap into place.

**Tech Stack:** Neovim v0.12.1, AstroNvim v6, lazy.nvim, blink-cmp, vim.lsp.config native API

**Spec:** `~/dev-setup/docs/superpowers/specs/2026-04-11-astronvim-v6-migration-design.md`

---

## File Map

| File | Action |
|---|---|
| `~/.config/astronvim_v6/lua/lazy_setup.lua` | Modify: `^5` → `^6` |
| `~/.config/astronvim_v6/lua/plugins/treesitter.lua` | Rewrite: migrate to AstroCore module |
| `~/.config/astronvim_v6/lua/plugins/astrolsp.lua` | Modify: update handler comment format |
| `~/.config/astronvim_v6/lua/community.lua` | Modify: nvim-cmp → blink-cmp |
| `~/.config/astronvim_v6/lua/plugins/dadbod.lua` | Modify: remove nvim-cmp block |
| `~/.config/astronvim_v6/lua/plugins/cmp-dadbod.lua` | Rewrite: blink-cmp API |
| `~/.config/astronvim_v6/lua/plugins/user.lua` | Modify: remove examples, adapt LuaSnip/autopairs |
| `~/.config/astronvim_v6/.neoconf.json` | Delete |

---

### Task 1: Setup isolated environment

**Files:**
- Create: `~/.config/astronvim_v6/` (from template)

- [ ] **Step 1: Clone the AstroNvim v6 template**

```bash
git clone https://github.com/AstroNvim/template ~/.config/astronvim_v6
rm -rf ~/.config/astronvim_v6/.git
```

- [ ] **Step 2: Copy existing user config files**

```bash
cp -r ~/.config/nvim/lua/* ~/.config/astronvim_v6/lua/
```

- [ ] **Step 3: Remove .neoconf.json (removed in v6)**

```bash
rm -f ~/.config/astronvim_v6/.neoconf.json
```

- [ ] **Step 4: Verify files are in place**

```bash
ls ~/.config/astronvim_v6/lua/plugins/
```

Expected output: `astrocore.lua  astrolsp.lua  astroui.lua  cmp-dadbod.lua  dadbod.lua  dotenv-priority.lua  mason.lua  neo-tree.lua  neotest.lua  none-ls.lua  treesitter.lua  user.lua`

---

### Task 2: Bump AstroNvim version to v6

**Files:**
- Modify: `~/.config/astronvim_v6/lua/lazy_setup.lua`

- [ ] **Step 1: Update version string**

In `~/.config/astronvim_v6/lua/lazy_setup.lua`, change line 4:
```lua
-- Before
version = "^5", -- Remove version tracking to elect for nightly AstroNvim
-- After
version = "^6", -- Remove version tracking to elect for nightly AstroNvim
```

- [ ] **Step 2: First boot sanity check**

```bash
NVIM_APPNAME=astronvim_v6 nvim --headless +qa 2>&1 | head -20
```

Expected: no fatal errors (warnings about plugins updating are fine)

---

### Task 3: Migrate treesitter.lua to AstroCore module

**Files:**
- Rewrite: `~/.config/astronvim_v6/lua/plugins/treesitter.lua`

In v6, nvim-treesitter is a parser-only downloader. Highlighting and parser management move to AstroCore's `treesitter` module.

- [ ] **Step 1: Replace treesitter.lua entirely**

Replace the full content of `~/.config/astronvim_v6/lua/plugins/treesitter.lua` with:

```lua
-- Treesitter configuration via AstroCore (v6 — nvim-treesitter is now parser-only)

---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@type AstroCoreOpts
  opts = {
    treesitter = {
      ensure_installed = {
        "lua",
        "vim",
      },
      highlight = true,
    },
  },
}
```

---

### Task 4: Update astrolsp.lua handler format

**Files:**
- Modify: `~/.config/astronvim_v6/lua/plugins/astrolsp.lua`

The handlers default handler no longer uses an unnamed function. It now uses the `"*"` key. The user config has no active handlers, just a commented example — update the comment.

- [ ] **Step 1: Update the handlers comment**

In `~/.config/astronvim_v6/lua/plugins/astrolsp.lua`, replace the handlers block (lines 48–55):

```lua
    -- customize how language servers are attached
    handlers = {
      -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
      -- function(server, opts) require("lspconfig")[server].setup(opts) end

      -- the key is the server that is being setup with `lspconfig`
      -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
      -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
    },
```

with:

```lua
    -- customize how language servers are attached
    handlers = {
      -- v6: default handler uses "*" key, server name passed as parameter
      -- ["*"] = function(server) vim.lsp.enable(server) end,

      -- disable a specific server:
      -- rust_analyzer = false,
      -- custom handler for a server:
      -- pyright = function(server) vim.lsp.enable(server) end,
    },
```

---

### Task 5: Migrate community.lua to blink-cmp

**Files:**
- Modify: `~/.config/astronvim_v6/lua/community.lua`

- [ ] **Step 1: Replace nvim-cmp with blink-cmp**

In `~/.config/astronvim_v6/lua/community.lua`, replace:

```lua
  { import = "astrocommunity.completion.nvim-cmp" },
```

with:

```lua
  { import = "astrocommunity.completion.blink-cmp" },
```

---

### Task 6: Remove nvim-cmp block from dadbod.lua

**Files:**
- Modify: `~/.config/astronvim_v6/lua/plugins/dadbod.lua`

The second block in `dadbod.lua` patches `hrsh7th/nvim-cmp`. Since we're migrating to blink-cmp, this block must be removed. The blink-cmp SQL integration is handled separately in `cmp-dadbod.lua`.

- [ ] **Step 1: Remove the nvim-cmp block**

In `~/.config/astronvim_v6/lua/plugins/dadbod.lua`, remove the entire second plugin entry (the block starting with `-- 3) Autocomplétion SQL via nvim-cmp`), keeping only the first entry. The final file should be:

```lua
return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    lazy = false,
    init = function()
      vim.g.db_ui_env_variable_url = "DATABASE_URL"
      vim.g.db_ui_env_variable_name = "DATABASE_NAME"
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 30
      vim.g.db_ui_auto_execute_table_helpers = 1
    end,
    keys = {
      { "<leader>db", "<cmd>DBUI<cr>", desc = "Open DBUI" },
      { "<leader>dt", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
      { "<leader>dq", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB buffer" },
      { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB connection" },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIFindBuffer", "DBUIAddConnection" },
  },
}
```

---

### Task 7: Rewrite cmp-dadbod.lua for blink-cmp

**Files:**
- Rewrite: `~/.config/astronvim_v6/lua/plugins/cmp-dadbod.lua`

`vim-dadbod-completion` supports blink-cmp natively via `vim_dadbod_completion.blink`. We register it as a blink source and activate it per SQL filetype.

- [ ] **Step 1: Replace cmp-dadbod.lua entirely**

```lua
-- blink-cmp integration for vim-dadbod-completion
return {
  "saghen/blink.cmp",
  optional = true,
  opts = function(_, opts)
    opts.sources = opts.sources or {}
    opts.sources.providers = opts.sources.providers or {}
    opts.sources.providers["dadbod"] = {
      name = "Dadbod",
      module = "vim_dadbod_completion.blink",
      score_offset = 85,
    }
    opts.sources.per_filetype = opts.sources.per_filetype or {}
    for _, ft in ipairs { "sql", "mysql", "plsql" } do
      local ftsources = opts.sources.per_filetype[ft] or {}
      table.insert(ftsources, "dadbod")
      opts.sources.per_filetype[ft] = ftsources
    end
    return opts
  end,
}
```

---

### Task 8: Clean up user.lua

**Files:**
- Modify: `~/.config/astronvim_v6/lua/plugins/user.lua`

Remove template examples (`presence.nvim`, `lsp_signature.nvim`). Adapt LuaSnip and autopairs to not use the internal `astronvim.plugins.configs.*` paths (which may not exist in v6).

- [ ] **Step 1: Replace user.lua entirely**

```lua
---@type LazySpec
return {

  -- === Dashboard ===
  {
    "folke/snacks.nvim",
    opts = {
      dashboard = {
        preset = {
          header = table.concat({
            " █████  ███████ ████████ ██████   ██████ ",
            "██   ██ ██         ██    ██   ██ ██    ██",
            "███████ ███████    ██    ██████  ██    ██",
            "██   ██      ██    ██    ██   ██ ██    ██",
            "██   ██ ███████    ██    ██   ██  ██████ ",
            "",
            "███    ██ ██    ██ ██ ███    ███",
            "████   ██ ██    ██ ██ ████  ████",
            "██ ██  ██ ██    ██ ██ ██ ████ ██",
            "██  ██ ██  ██  ██  ██ ██  ██  ██",
            "██   ████   ████   ██ ██      ██",
          }, "\n"),
        },
      },
    },
  },

  -- === Disabled plugins ===
  { "max397574/better-escape.nvim", enabled = false },

  -- === LuaSnip: extend javascript snippets to jsx ===
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip").filetype_extend("javascript", { "javascriptreact" })
    end,
  },

  -- === Autopairs: custom rules for tex/latex ===
  {
    "windwp/nvim-autopairs",
    config = function(_, opts)
      local npairs = require "nvim-autopairs"
      npairs.setup(opts)
      local Rule = require "nvim-autopairs.rule"
      local cond = require "nvim-autopairs.conds"
      npairs.add_rules {
        Rule("$", "$", { "tex", "latex" })
          :with_pair(cond.not_after_regex "%%")
          :with_pair(cond.not_before_regex("xxx", 3))
          :with_move(cond.none())
          :with_del(cond.not_after_regex "xx")
          :with_cr(cond.none()),
        Rule("a", "a", "-vim"),
      }
    end,
  },
}
```

---

### Task 9: Full validation in isolated environment

- [ ] **Step 1: Launch isolated nvim and let lazy bootstrap**

```bash
NVIM_APPNAME=astronvim_v6 nvim
```

Wait for lazy.nvim to install/update all plugins (first launch takes 30–60s). Press `q` to close the Lazy UI when done.

- [ ] **Step 2: Check health**

Inside nvim:
```
:checkhealth
```

Look for ERRORS (warnings are acceptable). Specifically check for no mentions of `neoconf`, `nvim-ufo`, or `nvim-lspconfig` setup errors.

- [ ] **Step 3: Check LSP health**

```
:checkhealth vim.lsp
```

Replaces old `:LspInfo`. Should show no configuration errors.

- [ ] **Step 4: Test LSP on a TypeScript file**

```bash
NVIM_APPNAME=astronvim_v6 nvim /tmp/test.ts
```

- Type some code, verify LSP diagnostics appear
- Press `i` to enter insert mode, type a letter, verify blink-cmp completion popup appears

- [ ] **Step 5: Test LSP on a Go file**

```bash
NVIM_APPNAME=astronvim_v6 nvim /tmp/test.go
```

Add `package main` and a function, verify gopls diagnostics.

- [ ] **Step 6: Test SQL completion**

```bash
NVIM_APPNAME=astronvim_v6 nvim /tmp/test.sql
```

Enter insert mode, type `SELECT`, verify blink-cmp shows SQL completions.

- [ ] **Step 7: Test dadbod UI**

Inside nvim: press `<leader>db` and verify DBUI opens.

- [ ] **Step 8: Test neotest**

Open a Jest test file, press `<leader>tn` and verify neotest runs.

- [ ] **Step 9: Verify catppuccin theme**

Confirm colorscheme is catppuccin (not a fallback).

---

### Task 10: Swap isolated config into production

Only proceed after Task 9 passes all validation steps.

- [ ] **Step 1: Backup old data directories**

```bash
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
```

- [ ] **Step 2: Backup old config**

```bash
mv ~/.config/nvim ~/.config/nvim.bak
```

- [ ] **Step 3: Move new config into place**

```bash
mv ~/.config/astronvim_v6 ~/.config/nvim
```

- [ ] **Step 4: Launch production nvim**

```bash
nvim
```

Verify lazy bootstraps cleanly. Run `:checkhealth` once more.

- [ ] **Step 5: Rollback instructions (if needed)**

If anything is broken after swap:
```bash
mv ~/.config/nvim ~/.config/astronvim_v6
mv ~/.config/nvim.bak ~/.config/nvim
mv ~/.local/share/nvim.bak ~/.local/share/nvim
mv ~/.local/state/nvim.bak ~/.local/state/nvim
mv ~/.cache/nvim.bak ~/.cache/nvim
```
