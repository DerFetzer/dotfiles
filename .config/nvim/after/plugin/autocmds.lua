local nd_group = vim.api.nvim_create_augroup("NerdTree", { clear = true })
vim.api.nvim_create_autocmd("VimEnter", { command = "NERDTree | wincmd p", group = nd_group})
