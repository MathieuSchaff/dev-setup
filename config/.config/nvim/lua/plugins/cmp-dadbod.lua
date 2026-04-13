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
