return {
  "tpope/vim-dotenv",
  lazy = false,
  priority = 1000,
  init = function()
    -- Pas de mappings automatiques
    vim.g.dotenv_enable_mapping = 0

    -- Charge .env puis surcharge .env.local (priorité au local)
    local function load_envs()
      local cwd = vim.fn.getcwd()
      local function find_up(fname)
        local found = vim.fs.find(fname, { upward = true, path = cwd })[1]
        return found
      end

      -- 1) seed avec .env (silencieux si absent)
      local env = find_up ".env"
      if env then pcall(vim.cmd, "silent! Dotenv " .. vim.fn.fnameescape(env)) end

      -- 2) surcharge avec .env.local (force l'override)
      local envlocal = find_up ".env.local"
      if envlocal then pcall(vim.cmd, "silent! Dotenv! " .. vim.fn.fnameescape(envlocal)) end
    end

    -- Au démarrage et quand tu changes de dossier
    vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
      callback = load_envs,
    })

    -- Fallback : si la var n'est pas chargée quand tu ouvres un buffer, recharge
    vim.api.nvim_create_autocmd("BufEnter", {
      callback = function()
        if vim.fn.exists "$DATABASE_URL" == 0 then load_envs() end
      end,
    })
  end,
}
