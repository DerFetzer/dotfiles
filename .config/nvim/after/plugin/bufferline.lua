require('bufferline').setup {
    options = {
        close_command = "bdelete! %d | bnext",
        right_mouse_command = "bdelete! %d | bnext",
        offsets = {
            {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
            }
        },
    }
}
print("bufferline")
