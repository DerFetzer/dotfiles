local wk = require("which-key")

require("mason").setup()

-- Mappings.

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    wk.add({
        buffer = bufnr,
        { "gD", vim.lsp.buf.declaration,                   desc = "Go to declaration" },
        { "gd", "<cmd>Telescope lsp_definitions<cr>",      desc = "Go to definition" },
        { "gr", "<cmd>Telescope lsp_references<cr>",       desc = "Show references" },
        { "gR", "<cmd>TroubleToggle lsp_references<cr>",   desc = "Trouble references" },
        { "gi", "<cmd>Telescope lsp_implementations<cr>",  desc = "Go to implementation" },
        { "gt", "<cmd>Telescope lsp_type_definitions<cr>", desc = "Go to type definition" },
        {
            "ts",
            "<cmd>Telescope lsp_dynamic_workspace_symbols ignore_symbols=variable<cr>",
            desc = "Find workspace symbols"
        },
        { "td",         "<cmd>Telescope lsp_document_symbols<cr>", desc = "Find document symbols" },
        { "K",          vim.lsp.buf.hover,                         desc = "Hover" },
        { "<C-k>",      vim.lsp.buf.signature_help,                desc = "Show signature" },
        { "<leader>cr", vim.lsp.buf.rename,                        desc = "Rename" },
        { "<leader>ca", vim.lsp.buf.code_action,                   desc = "Code action" },
        { "<leader>f",  vim.lsp.buf.format,                        desc = "Format" },
    }
    )

    wk.add({
        buffer = bufnr,
        mode = { "v" },
        { "<leader>f",  vim.lsp.buf.format,      desc = "Format" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action" },
    })
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

    if client.server_capabilities.inlayHintProvider then
        vim.lsp.inlay_hint.enable(true)
    end
end

local function wrap_on_attach(client_name)
    local builtin_on_attach = vim.lsp.config[client_name].on_attach
    return function(client, bufnr)
        if builtin_on_attach ~= nil then
            builtin_on_attach(client, bufnr)
        end
        on_attach(client, bufnr)
    end
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local settings
local dir_names = vim.fn.split(vim.fn.getcwd(), "/")
local dir_name = dir_names[#dir_names]

if dir_name == "rust" then
    -- Overrides for rustc
    settings = {
        ["rust-analyzer"] = {
            check = {
                overrideCommand = { "python3", "x.py", "check", "--json-output" }
            },
            rustfmt = {
                overrideCommand = { "./build/x86_64-unknown-linux-gnu/stage0/bin/rustfmt", "--edition=2021" }
            },
            buildScript = {
                overrideCommand = { "python3", "x.py", "check", "--json-output" }
            },
            rustc = {
                source = { "./Cargo.toml" }
            }
        }
    }
else
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy"
            }
        }
    }
end

vim.g.rustaceanvim = {
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
            wk.add({
                buffer = buffer,
                { "<leader>r",  group = "Rust" },
                { "<leader>rr", function() vim.cmd.RustLsp("runnables") end,         desc = "Runnables" },
                { "<leader>rd", function() vim.cmd.RustLsp("debuggables") end,       desc = "Debuggables" },
                { "<leader>rt", function() vim.cmd.RustLsp("testables") end,         desc = "Testables" },
                { "<leader>rk", function() vim.cmd.RustLsp("hover", "actions") end,  desc = "Hover actions" },
                { "<leader>rc", function() vim.cmd.RustLsp("codeActios") end,        desc = "Code action group" },
                { "<leader>re", function() vim.cmd.RustLsp("expandMacro") end,       desc = "Expand macro" },
                { "<leader>rE", function() vim.cmd.RustLsp("explainError") end,      desc = "Explain Error" },
                { "<leader>rR", function() vim.cmd.RustLsp("renderDiagnostics") end, desc = "Render diagnostics" },
                { "<leader>ro", function() vim.cmd.RustLsp("openDocs") end,          desc = "Open external docs" },
            })
        end,
        settings = settings
    }
}

vim.lsp.config("*", {
    capabilities = capabilities,
})

vim.lsp.enable('basedpyright')
vim.lsp.config('basedpyright', {
    on_attach = wrap_on_attach('basedpyright')
})

require 'lspconfig'.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        })
    end,
    settings = {
        Lua = {}
    }
}


vim.lsp.enable('clangd')
vim.lsp.config('clangd', {
    on_attach = wrap_on_attach('clangd')
})

vim.lsp.enable('ruff')
vim.lsp.config('ruff', {
    on_attach = function(client, bufnr)
        client.server_capabilities.hoverProvider = false
    end,
})

vim.lsp.enable('tinymist')
vim.lsp.config('tinymist', {
    on_attach = wrap_on_attach('tinymist'),
    settings = {
        exportPdf = "never" -- Choose onType, onSave or never.
    }
})
vim.filetype.add({
    extension = { typ = 'typst' }
})

require("crates").setup {
    lsp = {
        enabled = true,
        on_attach = on_attach,
        actions = true,
        completion = true,
        hover = true,
    }
}

vim.lsp.enable('nushell')
vim.lsp.config('nushell', {
    on_attach = wrap_on_attach('nushell')
})

-- Wait for fix of https://github.com/nvim-java/nvim-java/issues/384
-- require('java').setup()
-- vim.lsp.enable('jdtls')

-- Diagnostics
vim.diagnostic.config {
    update_in_insert = true,
}

-- null-ls
local sources = {
    require("null-ls").builtins.diagnostics.hadolint,
    require("null-ls").builtins.diagnostics.selene,
    require("null-ls").builtins.diagnostics.rstcheck,
    require("null-ls").builtins.diagnostics.cppcheck,
    require("null-ls").builtins.formatting.black,
}

require("null-ls").setup({
    sources = sources,
})
