-- local nd_group = vim.api.nvim_create_augroup("NerdTree", { clear = true })
-- vim.api.nvim_create_autocmd("VimEnter", { command = "NERDTree | wincmd p", group = nd_group })

local lsp_group = vim.api.nvim_create_augroup("LSP", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre",
    { pattern = { "*.rs", "*.toml", "*.c", "*.h", "*.lua" }, callback = vim.lsp.buf.formatting_sync, group = lsp_group })

local function manual_folding()
    if vim.fn.getfsize(vim.fn.expand("%")) > 5 * 1024 * 1024 then
        vim.wo.foldmethod = "manual"
    end
end

local large_file_group = vim.api.nvim_create_augroup("LF", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePre", "BufReadPre" },
    { callback = manual_folding, group = large_file_group })
