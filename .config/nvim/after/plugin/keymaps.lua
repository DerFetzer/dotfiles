local wk = require("which-key")
local Hydra = require('hydra')

-- Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.register({
    ['<leader>e'] = { vim.diagnostic.open_float, "Diagnostics open" },
    ['<leader>r'] = { vim.diagnostic.goto_prev, "Diagnostics previous" },
    ['<leader>n'] = { vim.diagnostic.goto_next, "Diagnostics next" },
    ['<leader>E'] = { vim.diagnostic.setloclist, "Diagnostics locations" },
})

-- Telescope
local tele = require("telescope.builtin")
local tele_utils = require("telescope.utils")
wk.register({
    t = {
        name = "Telescope",
        t = { "<cmd>Telescope<cr>", "List builtin pickers" },
        h = { "<cmd>Telescope find_files hidden=true<cr>", "Find hidden files" },
        f = { "<cmd>Telescope find_files<cr>", "Find files" },
        g = { "<cmd>Telescope live_grep<cr>", "Grep in files" },
        G = {
            name = "Git",
            h = { "<cmd>Telescope git_bcommits<cr>", "Buffer history" },
            H = { "<cmd>Telescope git_commits<cr>", "History" },
            b = { "<cmd>Telescope git_branches<cr>", "Branches" },
        },
        l = {
            name = "Grep in files of language",
            p = { function() tele.live_grep({ glob_pattern = { '*.py', '*.pxi' } }) end, "Python" },
            r = { function() tele.live_grep({ glob_pattern = { '*.rs', 'Cargo.toml' } }) end, "Rust" },
            c = { function() tele.live_grep({ glob_pattern = { '*.c', '*.h', '*.cpp', '*.hpp' } }) end, "C/C++" },
        },
        b = { "<cmd>Telescope buffers<cr>", "Find open buffers" },
        r = { "<cmd>Telescope resume<cr>", "Last picker" },
        o = { "<cmd>Telescope oldfiles<cr>", "Recent files" },
        n = { "<cmd>Telescope grep_string<cr>", "Grep in files for word under cursor" },
        H = { "<cmd>Telescope help_tags<cr>", "Help tags" },
        w = { "<cmd>Telescope workspaces<cr>", "Workspaces" },
        d = { function() tele.live_grep({ cwd = tele_utils.buffer_dir() }) end, "Grep in files in buffer folder" },
    }
}, { prefix = "<leader>" })

-- buffers
local function closeBuffer()
    local treeView = require('nvim-tree.view')
    local bufferline = require('bufferline')

    -- check if NvimTree window was open
    local explorerWindow = treeView.get_winnr()
    if explorerWindow == nil then
        vim.cmd('Bdelete! ')
        return
    end
    local wasExplorerOpen = vim.api.nvim_win_is_valid(explorerWindow)

    local bufferToDelete = vim.api.nvim_get_current_buf()

    -- TODO: handle modified buffers
    -- local isModified = vim.api.nvim_eval('getbufvar(' .. bufferToDelete .. ', "&mod")')

    if wasExplorerOpen then
        -- switch to previous buffer (tracked by bufferline)
        bufferline.cycle(-1)
    end

    -- delete initially open buffer
    vim.cmd('Bdelete! ' .. bufferToDelete)
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
local neogit = require('neogit')
wk.register({
    g = {
        name = "Git",
        b = { "<cmd>Gitsigns blame_line<cr>", "Blame line" },
        B = { "<cmd>Gitsigns toggle_current_line_blame<cr>", "Toggle blame current line" },
        d = { "<cmd>Gitsigns diffthis<cr>", "Diff" },
        p = { "<cmd>Gitsigns preview_hunk<cr>", "Preview hunk" },
        h = { "<cmd>Gitsigns next_hunk<cr>", "Next hunk" },
        H = { "<cmd>Gitsigns previous_hunk<cr>", "Previous hunk" },
        r = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
        R = { "<cmd>Gitsigns reset_buffer<cr>", "Reset buffer" },
        n = { neogit.open, "Neogit" },
    }
}, { prefix = "<leader>" })

-- Debugging
local dap = require('dap')
local dapui = require('dapui')
wk.register({
    d = {
        name = "Debugging",
        b = { dap.toggle_breakpoint, "Toggle breakpoint" },
        B = { function()
            dap.set_breakpoint(vim.fn.input('Condition: '))
        end,
            "Set conditional breakpoint" },
        u = { dapui.toggle, "UI" },
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
        o = { "<cmd>SymbolsOutline<cr>", "Outline" },
        u = { "<cmd>UndotreeToggle<cr>", "Undotree" },
    }
}, { prefix = "<leader>" })

-- Insert
wk.register({
    ["<C-BS>"] = { "<C-W>", "Delete word before cursor" },
    ["<C-H>"] = { "<C-W>", "Delete word before cursor" },
}, { mode = "i" })


-- Crates
local crates = require('crates')
wk.register({
    C = {
        name = "Crates",
        t = { crates.toggle, "Toggle" },
        r = { crates.reload, "Reload" },
        v = { crates.show_versions_popup, "Show versions" },
        f = { crates.show_features_popup, "Show features" },
        d = { crates.show_dependencies_popup, "Show dependencies" },
        u = { crates.update_crate, "Update crate" },
        a = { crates.update_all_crates, "Update all crates" },
        U = { crates.upgrade_crate, "Upgrade crate" },
        A = { crates.upgrade_all_crates, "Upgrade all crates" },
        H = { crates.open_homepage, "Open homepage" },
        R = { crates.open_repository, "Open repo´" },
        D = { crates.open_documentation, "Open docs" },
        C = { crates.open_crates_io, "Open crates.io" },
    }
}, { prefix = "<leader>" })

wk.register({
    C = {
        name = "Crates",
        u = { crates.update_crates, "Update crates" },
        U = { crates.upgrade_crates, "Upgrade crates" },
    }
}, { prefix = "<leader>", mode = "v" })


-- Trouble
wk.register({
    x = {
        name = "Trouble",
        x = { "<cmd>TroubleToggle<cr>", "Toggle" },
        w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "Workspace" },
        d = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document" },
        r = { "<cmd>TroubleToggle lsp_references<cr>", "LSP references" },
        D = { "<cmd>TroubleToggle lsp_definitions<cr>", "Lsp definitions" },
        t = { "<cmd>TroubleToggle lsp_type_definitions<cr>", "Lsp type definitions" },
        l = { "<cmd>TroubleToggle loclist<cr>", "Loclist" },
        q = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix" },
    }
}, { prefix = "<leader>" })

-- Windows
wk.register({
    w = {
        w = { "<cmd>WhichKey <c-w><cr>", "Window" },
        u = { "<C-W>k", "Up" },
        t = { "<C-W>h", "Left" },
        e = { "<C-W>l", "Right" },
        i = { "<C-W>j", "Down" },
        q = { "<C-W>q", "Quit" },
        h = { "<cmd>split<cr>", "Split horizontally" },
        v = { "<cmd>vsplit<cr>", "Split vertically" },
    }
}, { prefix = "<leader>" })

Hydra({
    name = "Window size",
    config = {
        color = 'amaranth',
        -- color = 'teal',
        -- color = 'pink',
        invoke_on_body = true,
        hint = {
            type = "window",
        },
    },
    mode = "n",
    body = "<leader>ws",
    heads = {
        { "+", "5<C-W>+", { desc = "Increase height" } },
        { "-", "5<C-W>-", { desc = "Decrease height" } },
        { ">", "5<C-W>>", { desc = "Increase width" } },
        { "<", "5<C-W><", { desc = "Decrease width" } },
        { "=", "<C-W>=",  { desc = "Equally high and wide" } },
    },
})

-- Navigation
wk.register({
    ["<C-D>"] = { "<C-D>zz", "Down" },
    ["<C-U>"] = { "<C-U>zz", "Up" },
})
