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
local tele = require("telescope.builtin")
wk.register({
    t = {
        name = "Telescope",
        t = { "<cmd>Telescope<cr>", "List builtin pickers" },
        h = { "<cmd>Telescope find_files hidden=true<cr>", "Find hidden files" },
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
        g = { "<cmd>Telescope live_grep<cr>", "Grep in files" },
        l = {
            name = "Find files of language",
            p = { function() tele.live_grep({ glob_pattern = { '*.py', '*.pxi' } }) end, "Python" },
            r = { function() tele.live_grep({ glob_pattern = { '*.rs', 'Cargo.toml' } }) end, "Rust" },
            c = { function() tele.live_grep({ glob_pattern = { '*.c', '*.h', '*.cpp', '*.hpp' } }) end, "C/C++" },
        },
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

-- Git
wk.register({
    g = {
        name = "Git",
        b = { "<cmd>Gitsigns blame_line<cr>", "Blame line" },
        B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle blame current line" },
        d = { "<cmd>Gitsigns diffthis<cr>", "Diff" },
        p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview hunk" },
        h = { "<cmd>Gitsigns next_hunk<cr>", "Next hunk" },
        H = { "<cmd>Gitsigns previous_hunk<cr>", "Previous hunk" },
    }
}, { prefix = "<leader>" })

-- Debugging
local dap = require('dap')
wk.register({
    d = {
        name = "Debugging",
        b = { dap.toggle_breakpoint, "Toggle breakpoint" },
        B = { function()
            dap.set_breakpoint(vim.fn.input('Condition: '))
        end,
            "Set conditional breakpoint" },
    }
}, { prefix = "<leader>" })

wk.register({
    ["<F8>"] = { dap.step_into, "Step into" },
    ["<F9>"] = { dap.step_over, "Step over" },
    ["<F10>"] = { dap.continue, "Start/Continue debugging" },
    ["<S-F8>"] = { dap.step_out, "Step out" },
})

-- Panels
wk.register({
    p = {
        name = "Panels",
        t = { "<cmd>NvimTreeToggle<cr>", "Nvim Tree" },
        f = { "<cmd>NvimTreeFindFile<cr>", "Find file in Nvim Tree" },
        o = { "<cmd>SymbolsOutline<cr>", "Outline" }
    }
}, { prefix = "<leader>" })

-- Insert
wk.register({
    ["<C-BS>"] = { "<C-W>", "Delete word before cursor" },
}, { mode = "i"})
