-- lua/plugins/neo-tree.lua
return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- === POSITION À DROITE ===
    window = {
      position = "right",
    },

    -- === AFFICHER LES FICHIERS CACHÉS ===
    filesystem = {
      filtered_items = {
        visible = true, -- Rend visibles les fichiers filtrés
        show_hidden_count = true, -- Affiche le nombre de fichiers cachés
        hide_dotfiles = false, -- Ne cache PAS les fichiers commençant par un point
        hide_gitignored = true, -- Cache les fichiers ignorés par git (optionnel)
      },
    },
  },
}
