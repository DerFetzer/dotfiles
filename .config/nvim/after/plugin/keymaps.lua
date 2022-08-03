local wk = require("which-key")

-- Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.register({
    ['<leader>e'] = { vim.diagnostic.open_float, "Diagnostics open" },
    ['[d'] = { vim.diagnostic.goto_prev, "Diagnostics previous" },
    [']d'] = { vim.diagnostic.goto_next, "Diagnostics next" },
    ['<leader>q'] = { vim.diagnostic.setloclist, "Diagnostics locations" },
})

-- Telescope
-- local tele = require("telescope.builtin")
wk.register({
    t = {
        name = "Telescope",
        t = { "<cmd>Telescope<cr>", "List builtin pickers" },
        f = { "<cmd>Telescope find_files hidden=true<cr>", "Find files" },
        g = { "<cmd>Telescope live_grep<cr>", "Grep in files" },
        b = { "<cmd>Telescope buffers<cr>", "Find open buffers" },
    }
}, { prefix = "<leader>" })
