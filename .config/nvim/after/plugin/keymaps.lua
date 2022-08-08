local wk = require("which-key")

-- Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.register({
    ['<leader>e'] = { vim.diagnostic.open_float, "Diagnostics open" },
    ['[d'] = { vim.diagnostic.goto_prev, "Diagnostics previous" },
    [']d'] = { vim.diagnostic.goto_next, "Diagnostics next" },
    ['<leader>E'] = { vim.diagnostic.setloclist, "Diagnostics locations" },
})

-- Telescope
-- local tele = require("telescope.builtin")
wk.register({
    t = {
        name = "Telescope",
        t = { "<cmd>Telescope<cr>", "List builtin pickers" },
        h = { "<cmd>Telescope find_files hidden=true<cr>", "Find hidden files" },
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
        g = { "<cmd>Telescope live_grep<cr>", "Grep in files" },
        b = { "<cmd>Telescope buffers<cr>", "Find open buffers" },
        r = { "<cmd>Telescope resume<cr>", "Last picker" },
        o = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
        n = { "<cmd>Telescope grep_string<cr>", "Grep in files for word under cursor" },
    }
}, { prefix = "<leader>" })

-- buffers
local function closeBuffer()
    local treeView = require('nvim-tree.view')
    local bufferline = require('bufferline')

    -- check if NvimTree window was open
    local explorerWindow = treeView.get_winnr()
    if explorerWindow == nil then
        vim.cmd('bdelete! ')
        return
    end
    local wasExplorerOpen = vim.api.nvim_win_is_valid(explorerWindow)

    local bufferToDelete = vim.api.nvim_get_current_buf()

    -- TODO: handle modified buffers
    -- local isModified = vim.api.nvim_eval('getbufvar(' .. bufferToDelete .. ', "&mod")')

    if (wasExplorerOpen) then
        -- switch to previous buffer (tracked by bufferline)
        bufferline.cycle(-1)
    end

    -- delete initially open buffer
    vim.cmd('bdelete! ' .. bufferToDelete)
end

wk.register({
    q = { closeBuffer, "Close current buffer" },
    ["<leader>"] = { "<cmd>w<cr>", "Write current buffer" }
}, { prefix = "<leader>" })

wk.register({
    ['('] = { "<cmd>BufferLineCyclePrev<cr>", "Previous buffer" },
    [')'] = { "<cmd>BufferLineCycleNext<cr>", "Next buffer" },
})

-- ToggleTerm
local function termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

wk.register({
    ["<esc>"] = { termcodes("<C-\\><C-N>"), "End terminal mode" }
}, { mode = "t" })
