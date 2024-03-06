-- local nd_group = vim.api.nvim_create_augroup("NerdTree", { clear = true })
-- vim.api.nvim_create_autocmd("VimEnter", { command = "NERDTree | wincmd p", group = nd_group })

local lsp_group = vim.api.nvim_create_augroup("LSP", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = { "*.rs", "*.toml", "*.lua" },
    callback = function() vim.lsp.buf.format({ async = false }) end,
    group = lsp_group
})

local function manual_folding()
    if vim.fn.getfsize(vim.fn.expand("%")) > 5 * 1024 * 1024 then
        vim.wo.foldmethod = "manual"
    end
end

local large_file_group = vim.api.nvim_create_augroup("LF", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre", "BufReadPre" },
    { callback = manual_folding, group = large_file_group })

-- auto-reload files when modified externally
-- https://unix.stackexchange.com/a/383044
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
})

-- Kickstarter
-- https://github.com/nvim-lua/kickstart.nvim/blob/b83b2b061c1fab0e1a3a28c185345be7957e74cd/init.lua

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
        vim.highlight.on_yank()
    end,
})
