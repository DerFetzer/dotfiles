local langs = { "c", "lua", "python", "rust", "cpp", "nu" }

require('nvim-treesitter').install(langs)

require 'treesitter-context'.setup({})

-- Autocommands
local ts_group = vim.api.nvim_create_augroup("TS", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = (langs),
  callback = function()
      -- syntax highlighting, provided by Neovim
      vim.treesitter.start()
      -- folds, provided by Neovim
      vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo.foldmethod = 'expr'
      vim.wo.foldlevel = 99
      -- indentation, provided by nvim-treesitter
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
  group = ts_group
})
