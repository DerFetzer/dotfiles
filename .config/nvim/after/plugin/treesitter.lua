require('nvim-treesitter').install({ "c", "lua", "python", "rust", "cpp", "nu" })

vim.wo.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.wo.foldenable = false

require 'treesitter-context'.setup({})
