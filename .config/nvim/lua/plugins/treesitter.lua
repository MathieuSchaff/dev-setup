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
