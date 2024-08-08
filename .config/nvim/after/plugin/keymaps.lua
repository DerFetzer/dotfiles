local wk = require("which-key")
local Hydra = require('hydra')

-- Diagnostics
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
wk.add({
    { "<leader>e", vim.diagnostic.open_float, desc = "Diagnostics open" },
    { "<leader>r", vim.diagnostic.goto_prev,  desc = "Diagnostics previous" },
    { "<leader>n", vim.diagnostic.goto_next,  desc = "Diagnostics next" },
    { "<leader>E", vim.diagnostic.setloclist, desc = "Diagnostics locations" },
})

-- Quickfix
wk.add({
    { "<leader>R", "<cmd>cp<cr>", desc = "Quickfix previous" },
    { "<leader>N", "<cmd>cn<cr>", desc = "Quickfix next" },
})

-- Telescope
local tele = require("telescope.builtin")
local tele_utils = require("telescope.utils")
wk.add({
    { "<leader>t",   group = "Telescope" },

    { "<leader>tG",  group = "Git" },
    { "<leader>tGH", "<cmd>Telescope git_commits<cr>",                                                     desc = "History" },
    { "<leader>tGb", "<cmd>Telescope git_branches<cr>",                                                    desc = "Branches" },
    { "<leader>tGh", "<cmd>Telescope git_bcommits<cr>",                                                    desc = "Buffer history" },

    { "<leader>tH",  "<cmd>Telescope help_tags<cr>",                                                       desc = "Help tags" },
    { "<leader>tb",  "<cmd>Telescope buffers<cr>",                                                         desc = "Find open buffers" },
    { "<leader>td",  function() tele.live_grep({ cwd = tele_utils.buffer_dir() }) end,                     desc = "Grep in files in buffer folder" },
    { "<leader>tf",  "<cmd>Telescope find_files<cr>",                                                      desc = "Find files" },
    { "<leader>tg",  "<cmd>Telescope live_grep<cr>",                                                       desc = "Grep in files" },
    { "<leader>th",  "<cmd>Telescope find_files hidden=true no_ignore=true no_ignore_parent=true<cr>",     desc = "Find hidden files" },

    { "<leader>tl",  group = "Grep in files of language" },
    { "<leader>tlc", function() tele.live_grep({ glob_pattern = { '*.c', '*.h', '*.cpp', '*.hpp' } }) end, desc = "C/C++" },
    { "<leader>tlp", function() tele.live_grep({ glob_pattern = { '*.py', '*.pxi' } }) end,                desc = "Python" },
    { "<leader>tlr", function() tele.live_grep({ glob_pattern = { '*.rs', 'Cargo.toml' } }) end,           desc = "Rust" },

    { "<leader>tn",  "<cmd>Telescope grep_string<cr>",                                                     desc = "Grep in files for word under cursor" },
    { "<leader>to",  "<cmd>Telescope oldfiles<cr>",                                                        desc = "Recent files" },
    { "<leader>tr",  "<cmd>Telescope resume<cr>",                                                          desc = "Last picker" },
    { "<leader>tt",  "<cmd>Telescope<cr>",                                                                 desc = "List builtin pickers" },
    { "<leader>tw",  "<cmd>Telescope workspaces<cr>",                                                      desc = "Workspaces" },
})

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

wk.add({
    { "<leader><leader>", "<cmd>w<cr>", desc = "Write current buffer" },
    { "<leader>q",        closeBuffer,  desc = "Close current buffer" },
})

wk.add({
    { "(", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous buffer" },
    { ")", "<cmd>BufferLineCycleNext<cr>", desc = "Next buffer" },
})

-- ToggleTerm
local function termcodes(str)
    return vim.api.nvim_replace_termcodes(str, true, true, true)
end

wk.add({
    mode = { "t" },
    { "<esc>", termcodes("<C-\\><C-N>"), desc = "End terminal mode" }
})

-- Git
local neogit = require('neogit')
wk.add({
    { "<leader>g",  group = "Git" },
    { "<leader>gB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle blame current line" },
    { "<leader>gH", "<cmd>Gitsigns previous_hunk<cr>",             desc = "Previous hunk" },
    { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>",              desc = "Reset buffer" },
    { "<leader>gb", "<cmd>Gitsigns blame_line<cr>",                desc = "Blame line" },
    { "<leader>gd", "<cmd>Gitsigns diffthis<cr>",                  desc = "Diff" },
    { "<leader>gh", "<cmd>Gitsigns next_hunk<cr>",                 desc = "Next hunk" },
    { "<leader>gn", neogit.open,                                   desc = "Neogit" },
    { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>",              desc = "Preview hunk" },
    { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>",                desc = "Reset hunk" },
})

-- Debugging
local dap = require('dap')
local dapui = require('dapui')
wk.add({
    { "<leader>d",  group = "Debugging" },
    {
        "<leader>dB",
        function()
            dap.set_breakpoint(vim.fn.input('Condition: '))
        end,
        desc = "Set conditional breakpoint"
    },
    { "<leader>db", dap.toggle_breakpoint, desc = "Toggle breakpoint" },
    { "<leader>du", dapui.toggle,          desc = "UI" },
})

wk.add({
    { "<F8>",   dap.step_into, desc = "Step into" },
    { "<F9>",   dap.step_over, desc = "Step over" },
    { "<F10>",  dap.continue,  desc = "Start/Continue debugging" },
    { "<S-F8>", dap.step_out,  desc = "Step out" },
})

-- Panels
wk.add({
    { "<leader>p",  group = "Panels" },
    { "<leader>pf", "<cmd>NvimTreeFindFile<cr>", desc = "Find file in Nvim Tree" },
    { "<leader>po", "<cmd>AerialToggle!<cr>",    desc = "Outline" },
    { "<leader>pt", "<cmd>NvimTreeToggle<cr>",   desc = "Nvim Tree" },
    { "<leader>pu", "<cmd>UndotreeToggle<cr>",   desc = "Undotree" },
})

-- Insert
wk.add({
    mode = { "i" },
    { "<C-BS>", "<C-W>", desc = "Delete word before cursor" },
    { "<C-H>",  "<C-W>", desc = "Delete word before cursor" },
})


-- Crates
local crates = require('crates')
wk.add({
    { "<leader>C",  group = "Crates" },
    { "<leader>Ct", crates.toggle,                  desc = "Toggle" },
    { "<leader>Cr", crates.reload,                  desc = "Reload" },
    { "<leader>Cv", crates.show_versions_popup,     desc = "Show versions" },
    { "<leader>Cf", crates.show_features_popup,     desc = "Show features" },
    { "<leader>Cd", crates.show_dependencies_popup, desc = "Show dependencies" },
    { "<leader>Cu", crates.update_crate,            desc = "Update crate" },
    { "<leader>Ca", crates.update_all_crates,       desc = "Update all crates" },
    { "<leader>CU", crates.upgrade_crate,           desc = "Upgrade crate" },
    { "<leader>CA", crates.upgrade_all_crates,      desc = "Upgrade all crates" },
    { "<leader>CH", crates.open_homepage,           desc = "Open homepage" },
    { "<leader>CR", crates.open_repository,         desc = "Open repo´" },
    { "<leader>CD", crates.open_documentation,      desc = "Open docs" },
    { "<leader>CC", crates.open_crates_io,          desc = "Open crates.io" },
})

wk.add({
    mode = { "v" },
    { "<leader>C>", group = "Crates" },
    { "<leader>Cu", crates.update_crates,  desc = "Update crates" },
    { "<leader>CU", crates.upgrade_crates, desc = "Upgrade crates" },
})


-- Trouble
wk.add({
    { "<leader>x",  group = "Trouble" },
    { "<leader>xx", "<cmd>TroubleToggle<cr>",                       desc = "Toggle" },
    { "<leader>xD", "<cmd>TroubleToggle lsp_definitions<cr>",       desc = "Lsp definitions" },
    { "<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>",  desc = "Document" },
    { "<leader>xl", "<cmd>TroubleToggle loclist<cr>",               desc = "Loclist" },
    { "<leader>xq", "<cmd>TroubleToggle quickfix<cr>",              desc = "Quickfix" },
    { "<leader>xr", "<cmd>TroubleToggle lsp_references<cr>",        desc = "LSP references" },
    { "<leader>xt", "<cmd>TroubleToggle lsp_type_definitions<cr>",  desc = "Lsp type definitions" },
    { "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace" },
})

-- Windows
wk.add({
    { "<leader>ww", "<cmd>WhichKey <c-w><cr>", desc = "Window" },
    { "<leader>wq", "<C-W>q",                  desc = "Quit" },
    { "<leader>wi", "<C-W>j",                  desc = "Down" },
    { "<leader>wt", "<C-W>h",                  desc = "Left" },
    { "<leader>we", "<C-W>l",                  desc = "Right" },
    { "<leader>wu", "<C-W>k",                  desc = "Up" },
    { "<leader>wv", "<cmd>vsplit<cr>",         desc = "Split vertically" },
    { "<leader>wh", "<cmd>split<cr>",          desc = "Split horizontally" },
})

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
wk.add({
    { "<C-D>", "<C-D>zz", desc = "Down" },
    { "<C-U>", "<C-U>zz", desc = "Up" },
})
