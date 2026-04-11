-- lua/plugins/cmp-dadbod.lua
return {
  {
    "hrsh7th/nvim-cmp",
    -- se charge après nvim-cmp
    opts = function(_, opts)
      local cmp = require "cmp"
      -- sources dédiées aux fichiers SQL
      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = {
          { name = "vim-dadbod-completion" },
          { name = "buffer" },
        },
      })
      return opts
    end,
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
    },
  },
}
