-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  -- === THEMES ===
  -- https://github.com/AstroNvim/astrocommunity/tree/main/lua/astrocommunity/colorscheme.catppuccin
  { import = "astrocommunity.colorscheme.catppuccin" },

  -- === LANGAGES ESSENTIELS ===
  { import = "astrocommunity.pack.html-css" },
  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.typescript-all-in-one" }, -- TypeScript + Deno auto
  { import = "astrocommunity.pack.go" },
  { import = "astrocommunity.pack.json" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.eslint" },
  { import = "astrocommunity.pack.mdx" },
  { import = "astrocommunity.pack.prettier" },
  { import = "astrocommunity.pack.tailwindcss" },
  { import = "astrocommunity.pack.sql" },
  { import = "astrocommunity.pack.xml" },
  { import = "astrocommunity.pack.full-dadbod" },
  -- To be used sometimes ( commented out for now )
  --{ import = "astrocommunity.pack.bash" },
  -- { import = "astrocommunity.pack.prisma" },
  --  { import = "astrocommunity.pack.svelte" },
  --  { import = "astrocommunity.pack.python" },
  -- { import = "astrocommunity.pack.rust" },

  -- === COOL STUFF ===

  -- Ultra-rapid navigation (just type 's' + 2 letters to go anywhere)
  { import = "astrocommunity.motion.flash-nvim" },

  -- Mark important files (like favorites)
  { import = "astrocommunity.motion.harpoon" },

  -- Modern completion and fast
  -- { import = "astrocommunity.completion.blink-cmp" },
  { import = "astrocommunity.completion.nvim-cmp" },

  { import = "astrocommunity.completion.supermaven-nvim" },
  -- { import = "astrocommunity.lsp.ts-error-translator-nvim" },

  -- === TESTS ===
  { import = "astrocommunity.test.neotest" },
}
