---@type LazySpec
return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-neotest/nvim-nio",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-neotest/neotest-jest",
  },

  -- Config de l'adapter Jest (tu peux ajuster jestCommand/jestConfigFile/cwd si monorepo)
  opts = function(_, opts)
    opts = opts or {}
    opts.adapters = opts.adapters or {}

    table.insert(
      opts.adapters,
      require "neotest-jest" {
        -- jestCommand = "npm test --", -- décommente si tu veux forcer
        jestArguments = function(defaultArgs) return defaultArgs end,
        -- jest_test_discovery = true,   -- si tu veux détecter it.each/test.each (désactive discovery globale)
        -- isTestFile = require("neotest-jest.jest-util").defaultIsTestFile,
      }
    )

    -- si tu actives jest_test_discovery, évite le spam :
    -- opts.discovery = { enabled = false }

    return opts
  end,

  -- Setup une fois (sans keymaps ici)
  config = function(_, opts) require("neotest").setup(opts) end,

  -- ✅ Les keymaps ici → visibles tout de suite & déclenchent le lazy-load
  keys = {
    {
      "<leader>tn",
      function() require("neotest").run.run() end,
      desc = "Test: nearest",
    },
    { "<leader>tf", function() require("neotest").run.run(vim.fn.expand "%") end, desc = "Test: file" },
    {
      "<leader>ta",
      function() require("neotest").run.run(vim.fn.getcwd()) end,
      desc = "Test: all (cwd)",
    },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Test: stop" },

    {
      "<leader>ts",
      function() require("neotest").summary.toggle() end,
      desc = "Test: summary",
    },
    {
      "<leader>to",
      function() require("neotest").output.open { enter = true } end,
      desc = "Test: output (float)",
    },
    {
      "<leader>tO",
      function() require("neotest").output_panel.toggle() end,
      desc = "Test: output panel",
    },
    { "<leader>tq", function() require("neotest").run.attach() end, desc = "Test: attach" },

    {
      "<leader>td",
      function() require("neotest").run.run { strategy = "dap" } end,
      desc = "Test: debug nearest (DAP)",
    },
    {
      "<leader>tD",
      function() require("neotest").run.run { vim.fn.expand "%", strategy = "dap" } end,
      desc = "Test: debug file (DAP)",
    },
  },
}
