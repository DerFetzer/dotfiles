require('telescope').setup {
    defaults = {
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--max-count=5" -- Limit number of matches per file
        },
        cache_picker = {
            num_pickers = 5,
            limit_entries = 1000,
        },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        }
    },
}
require("telescope").load_extension("ui-select")
require("telescope").load_extension("live_grep_args")
