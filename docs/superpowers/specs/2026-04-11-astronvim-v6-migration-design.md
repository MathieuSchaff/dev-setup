# AstroNvim v6 Migration — Design Spec

**Date:** 2026-04-11  
**Scope:** Migrate `~/.config/nvim` from AstroNvim v5 to v6  
**Neovim version:** v0.12.1 (already compatible)

---

## Context

AstroNvim v6 brings three major breaking changes:
1. LSP moved to `vim.lsp.config` native API (replaces nvim-lspconfig setup pattern)
2. nvim-treesitter refactored to parser-only downloader (modules/highlighting now via AstroCore)
3. Several plugins removed or renamed

The existing config is clean and minimal — most handlers/config are commented-out examples.

---

## Approach

**Isolated migration** — work in `~/.config/astronvim_v6` with `NVIM_APPNAME=astronvim_v6 nvim`, keep v5 at `~/.config/nvim` fully functional during the process. Swap once validated.

---

## Setup

```bash
git clone https://github.com/AstroNvim/template ~/.config/astronvim_v6
rm -rf ~/.config/astronvim_v6/.git
cp -r ~/.config/nvim/lua/* ~/.config/astronvim_v6/lua/
# Do NOT copy .neoconf.json (removed in v6)
```

---

## File Changes

### `lazy_setup.lua`
- Change `version = "^5"` → `version = "^6"`

### `treesitter.lua`
Migrate from direct nvim-treesitter opts to AstroCore treesitter module:

```lua
return {
  "AstroNvim/astrocore",
  opts = {
    treesitter = {
      ensure_installed = { "lua", "vim" },
      highlight = true,
    },
  },
}
```

### `astrolsp.lua`
- No functional changes needed (handlers are empty/commented)
- Update commented example to new `"*"` key format:
  ```lua
  handlers = {
    ["*"] = function(server) vim.lsp.enable(server) end,
  }
  ```

### `community.lua`
- Replace `{ import = "astrocommunity.completion.nvim-cmp" }` with `{ import = "astrocommunity.completion.blink-cmp" }`
- All other packs unchanged

### `dadbod.lua`
- Remove the second block (lines 33–51) that patches `hrsh7th/nvim-cmp`
- Keep first block (vim-dadbod-ui, keymaps, init)

### `cmp-dadbod.lua`
Rewrite entirely for blink-cmp API:

```lua
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

### `user.lua`
- Remove `andweeb/presence.nvim` (template example, unused)
- Remove `ray-x/lsp_signature.nvim` (template example, unused)
- Keep `folke/snacks.nvim` dashboard customization
- Keep `max397574/better-escape.nvim` disabled
- Rewrite LuaSnip config without internal AstroNvim path:
  ```lua
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      require("luasnip").setup(opts)
      require("luasnip").filetype_extend("javascript", { "javascriptreact" })
    end,
  }
  ```
- Rewrite autopairs config without internal AstroNvim path:
  ```lua
  {
    "windwp/nvim-autopairs",
    config = function(_, opts)
      local npairs = require("nvim-autopairs")
      npairs.setup(opts)
      local Rule = require("nvim-autopairs.rule")
      local cond = require("nvim-autopairs.conds")
      npairs.add_rules({
        Rule("$", "$", { "tex", "latex" })
          :with_pair(cond.not_after_regex "%%")
          :with_pair(cond.not_before_regex("xxx", 3))
          :with_move(cond.none())
          :with_del(cond.not_after_regex "xx")
          :with_cr(cond.none()),
        Rule("a", "a", "-vim"),
      })
    end,
  }
  ```

### Files to delete
- `~/.config/nvim/.neoconf.json` — neoconf.nvim removed in v6, replaced by native `vim.lsp.config`

### Files unchanged
- `astrocore.lua` — no breaking changes
- `astroui.lua` — no breaking changes
- `mason.lua` — no breaking changes
- `none-ls.lua` — no breaking changes
- `neotest.lua` — no breaking changes
- `neo-tree.lua` — no breaking changes
- `dotenv-priority.lua` — no breaking changes
- `polish.lua` — inactive, no changes

---

## Validation

```bash
NVIM_APPNAME=astronvim_v6 nvim
```

Checklist:
- `:checkhealth` — no critical errors
- `:checkhealth vim.lsp` — replaces old `:LspInfo`
- `:Lazy` — all plugins loaded
- Open `.ts` file — verify LSP + blink-cmp completion
- Open `.go` file — verify LSP
- Open `.sql` file — verify dadbod + blink-cmp SQL completion

---

## Swap (once validated)

```bash
mv ~/.local/share/nvim ~/.local/share/nvim.bak
mv ~/.local/state/nvim ~/.local/state/nvim.bak
mv ~/.cache/nvim ~/.cache/nvim.bak
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.config/astronvim_v6 ~/.config/nvim
```
