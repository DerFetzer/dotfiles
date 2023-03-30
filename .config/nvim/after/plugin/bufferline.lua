require('bufferline').setup {
    options = {
        close_command = function(bufnum)
            require('bufdelete').bufdelete(bufnum, true)
        end,
        right_mouse_command = function(bufnum)
            require('bufdelete').bufdelete(bufnum, true)
        end,
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            },
            {
                filetype = "undotree",
                text = "Undotree",
                highlight = "Directory",
                text_align = "left"
            }

        },
        diagnostics = "nvim_lsp"
    }
}
