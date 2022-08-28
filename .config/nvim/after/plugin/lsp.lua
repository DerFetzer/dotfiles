local wk = require("which-key")

require("mason").setup()
require("mason-lspconfig").setup()

-- Mappings.

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    vim.api.nvim_buf_set_option(bufnr, "formatexpr", "v:lua.vim.lsp.formatexpr()")
    vim.api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    wk.register({
        ['gD'] = { vim.lsp.buf.declaration, "Go to declaration" },
        ['gd'] = { "<cmd>Telescope lsp_definitions<cr>", "Go to definition" },
        ['gr'] = { "<cmd>Telescope lsp_references<cr>", "Show references" },
        ['gi'] = { "<cmd>Telescope lsp_implementations<cr>", "Go to implementation" },
        ['gt'] = { "<cmd>Telescope lsp_type_definitions<cr>", "Go to type definition" },
        ['ts'] = { "<cmd>Telescope lsp_dynamic_workspace_symbols ignore_symbols=variable<cr>", "Find workspace symbols" },
        ['td'] = { "<cmd>Telescope lsp_document_symbols<cr>", "Find document symbols" },
        ['K'] = { vim.lsp.buf.hover, "Hover" },
        ['<C-k>'] = { vim.lsp.buf.signature_help, "Show signature" },
        ['<leader>wa'] = { vim.lsp.buf.add_workspace_folder, "Add workspace folder" },
        ['<leader>wr'] = { vim.lsp.buf.remove_workspace_folder, "Remove workspace following" },
        ['<leader>wl'] = { function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
            "List workspace foders" },
        ['<leader>cr'] = { vim.lsp.buf.rename, "Rename" },
        ['<leader>ca'] = { vim.lsp.buf.code_action, "Code action" },
        ['<leader>f'] = { vim.lsp.buf.formatting, "Format" },
    },
        { buffer = bufnr })

    -- Highlight
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
        vim.api.nvim_clear_autocmds { buffer = bufnr, group = "lsp_document_highlight" }
        vim.api.nvim_create_autocmd("CursorHold", {
            callback = vim.lsp.buf.document_highlight,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Document Highlight",
        })
        vim.api.nvim_create_autocmd("CursorMoved", {
            callback = vim.lsp.buf.clear_references,
            buffer = bufnr,
            group = "lsp_document_highlight",
            desc = "Clear All the References",
        })
    end
end

local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

-- Setup rust_analyzer via rust-tools.nvim
local rt = require("rust-tools")
rt.setup({
    tools = {
        on_initialized = function()
            vim.cmd [[
              autocmd BufEnter,CursorHold,InsertLeave,BufWritePost *.rs silent! lua vim.lsp.codelens.refresh()
          ]]
        end,
    },
    server = {
        capabilities = capabilities,
        on_attach = function(client, buffer)
            on_attach(client, buffer)
            wk.register({
                r = {
                    name = "Rust",
                    r = { rt.runnables.runnables, "Runnables" },
                    d = { rt.debuggables.debuggables, "Debuggables" },
                    k = { rt.hover_actions.hover_actions, "Hover actions" },
                    c = { rt.code_action_group.code_action_group, "Code action group" },
                }
            }, { prefix = "<leader>", buffer = buffer })
        end,
        settings = {
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                }
            }
        }
    }
})

require 'lspconfig'.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}

require 'lspconfig'.sumneko_lua.setup {
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
    on_attach = on_attach,
    capabilities = capabilities,

}

require 'lspconfig'.clangd.setup {
    on_attach = on_attach,
    capabilities = capabilities,
}


-- Diagnostics
vim.diagnostic.config {
    update_in_insert = true,
}
