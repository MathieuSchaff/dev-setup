return {
  -- 2) Dadbod UI + completion
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    lazy = false, -- dispo tout de suite
    init = function()
      -- Utiliser les variables "projet" standard
      vim.g.db_ui_env_variable_url = "DATABASE_URL"
      vim.g.db_ui_env_variable_name = "DATABASE_NAME" -- (optionnel)
      -- UI confort
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_winwidth = 30
      vim.g.db_ui_auto_execute_table_helpers = 1
      -- Emplacement où sauver tes requêtes (<leader>W)
      -- vim.g.db_ui_save_location = vim.fn.expand("~/.local/share/db_ui")
    end,
    keys = {
      { "<leader>db", "<cmd>DBUI<cr>", desc = "Open DBUI" },
      { "<leader>dt", "<cmd>DBUIToggle<cr>", desc = "Toggle DBUI" },
      { "<leader>dq", "<cmd>DBUIFindBuffer<cr>", desc = "Find DB buffer" },
      { "<leader>da", "<cmd>DBUIAddConnection<cr>", desc = "Add DB connection" },
    },
    cmd = { "DBUI", "DBUIToggle", "DBUIFindBuffer", "DBUIAddConnection" },
  },

  -- 3) Autocomplétion SQL via nvim-cmp (buffer-local)
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require "cmp"
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "sql", "mysql", "plsql" },
        callback = function()
          cmp.setup.buffer {
            sources = {
              { name = "vim-dadbod-completion" },
              { name = "buffer" },
              { name = "path" },
            },
          }
          -- fallback intégré
          vim.bo.omnifunc = "vim_dadbod_completion#omni"
        end,
      })
      return opts
    end,
  },
}
